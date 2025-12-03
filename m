Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E72135B150;
	Wed,  3 Dec 2025 16:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780490; cv=none; b=E4Gb54Q9o95rxIX+a06U8RI4ud2kY+K+3+Xdz17o/Qtq7OGRYOKvVwVJChiO3i2ouvwhkoYzHe5U6KvYpowghSBPDy9oQRDlR7Y3LFWtC7dzZTd8W7YmQjI3UN8BexNWa16LRjMZeLT0FRrSVrCMUx2dFHXKJ5lttWgkF/R2+HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780490; c=relaxed/simple;
	bh=hwwxgvBE8K5cbIjKwm6jffCRcYjV9KH6lw7zai2d90o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuC+QOwZ/lu6OlnmDT4X0L4cu3iK1CmXauobuZp6DcoHnWoRVlVsrYEiyu+Jx/KnX4dXjulEAlYTjcqHfBp8Q4STaixF0Ozn4f8/tpW6sj3JYA7pIJ3XL5Ju4LeQosAlL1h/w6WvHa4QzFO29FPiAYbUpjfIrRhWxQWhhmi5tTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnBjvcFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnBjvcFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21CFC4CEF5;
	Wed,  3 Dec 2025 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780490;
	bh=hwwxgvBE8K5cbIjKwm6jffCRcYjV9KH6lw7zai2d90o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnBjvcFK6uKMilshyNaYxbh9gAoawQkeGwyMEbu74hV0j1teOfbJ3+3Jc/QGgzmBS
	 45zc3w0mmC2fkEBEcJZsRh4ifLKvPe1rIrRkB13hLd1q61dPwjFleM56DBVWmDx4WN
	 0pQFdfTn9PGaC38FLbWa5QkyDzUThDeIR97VubDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	"Kenneth R. Crudup" <kenny@panix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 563/568] usb: typec: ucsi: psy: Set max current to zero when disconnected
Date: Wed,  3 Dec 2025 16:29:25 +0100
Message-ID: <20251203152501.366072373@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jameson Thies <jthies@google.com>

[ Upstream commit 23379a17334fc24c4a9cbd9967d33dcd9323cc7c ]

The ucsi_psy_get_current_max function defaults to 0.1A when it is not
clear how much current the partner device can support. But this does
not check the port is connected, and will report 0.1A max current when
nothing is connected. Update ucsi_psy_get_current_max to report 0A when
there is no connection.

Fixes: af833e7f7db3 ("usb: typec: ucsi: psy: Set current max to 100mA for BC 1.2 and Default")
Cc: stable@vger.kernel.org
Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Kenneth R. Crudup <kenny@panix.com>
Rule: add
Link: https://lore.kernel.org/stable/20251017000051.2094101-1-jthies%40google.com
Link: https://patch.msgid.link/20251106011446.2052583-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adapted UCSI_CONSTAT() macro to direct flag access ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/psy.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/typec/ucsi/psy.c
+++ b/drivers/usb/typec/ucsi/psy.c
@@ -144,6 +144,11 @@ static int ucsi_psy_get_current_max(stru
 {
 	u32 pdo;
 
+	if (!(con->status.flags & UCSI_CONSTAT_CONNECTED)) {
+		val->intval = 0;
+		return 0;
+	}
+
 	switch (UCSI_CONSTAT_PWR_OPMODE(con->status.flags)) {
 	case UCSI_CONSTAT_PWR_OPMODE_PD:
 		if (con->num_pdos > 0) {


