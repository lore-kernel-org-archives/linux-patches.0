Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A7131AF37;
	Wed,  3 Dec 2025 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776818; cv=none; b=IoxdGzSWtTQRPSwayqpeJB0n0AUfkKZHlsK4yIvs4OFvjlA9ISJe8TWNofYD117m1W8IpmTUOoxrvW/jUIiLv5k2KHsy8wmqAFMT8vWUWczwnoeE5t1ywr5PypwihbWEhWZNF/FoWZgLo2IIMEKS9Zvy/JODf76vHGwozk1mbmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776818; c=relaxed/simple;
	bh=4gykzLVBQ8JIdHaJt1vYcCQg/ss/u6zL+nBcaRsFEvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQdRxBVO661BEc3rMFQKtytq0uMnLNja1SymIVEN3yaO8cVQUxitHJdih08G7vIMz+WVFCddvJY9BHvJq6bQqZ4Qx9jSp8XLiEurE+mO2sz7WLUG9JKJjOaWjPDqVt5lWQsj/wg94Qf7OBl4sHg7bB3lrjHeCFuwxrzoSU8G5oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rjmhCP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rjmhCP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC9BC4CEF5;
	Wed,  3 Dec 2025 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776818;
	bh=4gykzLVBQ8JIdHaJt1vYcCQg/ss/u6zL+nBcaRsFEvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rjmhCP98mZaB0Hz+pSLD80pZ9XMhLFnEvEZb5xtM49ircgZCwbucn7c+iBVk2Ggm
	 2dN5lPiZ6Wdn5lOiqnUf84St9OvmK/5otAT4n6lKGPNcxHOD/BqqrBnZyntwJDaSFy
	 vhtMYW+eXtUo9rs7m7MlMFAVmBqs4PamHbbT29uU=
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
Subject: [PATCH 5.10 296/300] usb: typec: ucsi: psy: Set max current to zero when disconnected
Date: Wed,  3 Dec 2025 16:28:20 +0100
Message-ID: <20251203152411.588485015@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -123,6 +123,11 @@ static int ucsi_psy_get_current_max(stru
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


