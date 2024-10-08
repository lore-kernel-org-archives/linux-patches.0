Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52FE1DF26B;
	Tue,  8 Oct 2024 12:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390106; cv=none; b=TCZ86IuVAm9QlH++GSUcWJUe25MhbfM8jx9DG6NgRd99UGV8pJXrGPGmVS+xEkWbCOwJucqYb90fqZ1DDpzsqooydFmVVYtd7bnOhm4OBS62rH+rOgv/uDbHHtwSrqWtehi659im4/1P/uHxAS0qXkA+vv7lvvxl18pFGjJ6kf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390106; c=relaxed/simple;
	bh=mRxjXpRy301z+CIkpfLNCurtdPH9qoAMCan9O343ZNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpaqProjHZHX26DzLiN03BGvnv1IMFypQF8beRLfJdehX9KVmrq5t7aYFEJOd6g1ilzzdt+a+FHENexAWWch+E8MiISMcnWcAnGIOn25cq/YGD6bUE1nFizNEwxwMR1gD5Lqfy3G6pRqnrnNnhcd7vtNRrwx/3fqUfpwSl7ooXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMHvJ62B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMHvJ62B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C227C4CECD;
	Tue,  8 Oct 2024 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390106;
	bh=mRxjXpRy301z+CIkpfLNCurtdPH9qoAMCan9O343ZNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMHvJ62Bot69qj1vTq1SbOvZ9Wqj2T3QMCvmbsXf1om9FGru3JdI+nXhiIymaggky
	 hBt3AKM/VGe8Fie6c0Nk/sOxI67Gq5D6bPY0WiYL+euN8vWFLZNiYAkSH3G1tBKzUK
	 bowOJTjHSlduN58IwjEk2AsYxZ2OWQIcyIgL/PeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Pauk <pauk.denis@gmail.com>,
	Attila <attila@fulop.one>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 161/482] hwmon: (nct6775) add G15CF to ASUS WMI monitoring list
Date: Tue,  8 Oct 2024 14:03:44 +0200
Message-ID: <20241008115654.641540195@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 1f432e4cf1dd3ecfec5ed80051b4611632a0fd51 ]

Boards G15CF has got a nct6775 chip, but by default there's no use of it
because of resource conflict with WMI method.

Add the board to the WMI monitoring list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Tested-by: Attila <attila@fulop.one>
Message-ID: <20240812152652.1303-1-pauk.denis@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 9aa4dcf4a6f33..096f1daa8f2bc 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1269,6 +1269,7 @@ static const char * const asus_msi_boards[] = {
 	"EX-B760M-V5 D4",
 	"EX-H510M-V3",
 	"EX-H610M-V3 D4",
+	"G15CF",
 	"PRIME A620M-A",
 	"PRIME B560-PLUS",
 	"PRIME B560-PLUS AC-HES",
-- 
2.43.0



