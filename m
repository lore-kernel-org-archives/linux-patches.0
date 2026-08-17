Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8DC3D7D70;
	Mon, 17 Aug 2026 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980543; cv=none; b=BEfKj7snwDW5+IKCVzBBv0LVFngS3/kfSWfVpspKATWj7g7AjUeTk3EQXLDd9O9YB0f0T/cPysD1Pskxzq1IyXtCAlpkyhESUr74BOuMLAfhSkR9SCS+Bs7TFRuxDeejH4Wzn6B4rlY9AvBQRECQSlvHl8t7+9RJ0nSHptPZVhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980543; c=relaxed/simple;
	bh=8nqnkgQ/4BvP/xQuQWktymzQHfi3bRe0VDnhr2lOXvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw3UzW3XJSEXpcEfYcY0XZtdeCDswXJ4217O47ePSSuR0QDo1xIoTL3vjTooGciEs7jDOIpZwCexG8YTMityK/GjQWZrBwlDaK1dSg7I7tEr87GXONL53zK4RHqFLekxTKL15PBzyYAGqLTRH6hRggBSpDKbHxkSgxQqCAzBPJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgHZv5ov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgHZv5ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330031F000E9;
	Mon, 17 Aug 2026 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980541;
	bh=wdpXyXnCcO8Q4c9D/WrzC7ZBCakKdEuStkooN6+KXOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgHZv5ov/8qmb6gHL5+PUEHZVmqNk+tWJCdAurLqPaZR0YqYh0hS3papz1EFUW31L
	 vkszj8x4pmz/YXyK44wJ7EqRXSBtR+UPW/fNWUICyUUbPBZvlMrm9NJlh1Ez3KCoaL
	 JFTVysMlcrvGnXwZ0POi/K+y6YlD7SvXOhn4pa3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Khalifa <ahmad@khalifa.ws>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 608/609] hwmon: (nct6775) Fix register for nct6799
Date: Mon, 17 Aug 2026 15:35:04 +0200
Message-ID: <20260817132603.972189098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Ahmad Khalifa <ahmad@khalifa.ws>

commit 368da76be8df60e9228a41b7d46e7836a67158fd upstream.

Datasheet and variable name point to 0xe6

Fixes: aee395bb1905 ("hwmon: (nct6755) Add support for NCT6799D")
Signed-off-by: Ahmad Khalifa <ahmad@khalifa.ws>
Link: https://lore.kernel.org/r/20230715145831.1304633-1-ahmad@khalifa.ws
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nct6775-platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -586,7 +586,7 @@ nct6775_check_fan_inputs(struct nct6775_
 		int creb;
 		int cred;
 
-		cre6 = sio_data->sio_inb(sio_data, 0xe0);
+		cre6 = sio_data->sio_inb(sio_data, 0xe6);
 
 		sio_data->sio_select(sio_data, NCT6775_LD_12);
 		cre0 = sio_data->sio_inb(sio_data, 0xe0);


