Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A043019C7;
	Wed, 10 Dec 2025 07:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352100; cv=none; b=Whk1kQEw1Z3ABoL0ebQRptGcmN8Mf6KNeO+UcB7a77arN6qcKlQVIgx/xmsyCB/uhTosuRYeDvtWaF5M/DWe9ZfGACjpHkHYf1LaWxhAACCMhM8doOZ7/i1lGuqxmNHaIsiXVJmjBu12L8cSE3PQzZvQNUJzGmqgL3t2pH6myh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352100; c=relaxed/simple;
	bh=EbwX7zJcsWcgJJE94/fQPU8oAsjKXW+RhbOja9QDxGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YhMft5+AH/4Jzbp+XTJk0mnwsu7sDKX0CQhVW+JVAqu+lxk71Cq+22Uga8TGUH5F9SYpDKT11yd5+5cF0bIEmk3M9y6UtmIgSo9U7KgT0Md1eSX0Y1CBg3Ga1S3vaQPAXyFDfd/1WPP1Yidxb7wycqHcQ9q5ACh5tbsp6Az39H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWHVty41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWHVty41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA52C4CEF1;
	Wed, 10 Dec 2025 07:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352100;
	bh=EbwX7zJcsWcgJJE94/fQPU8oAsjKXW+RhbOja9QDxGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWHVty41BIvBzh2yTdakQ/oENz+8q+W9W9gTdbvgZ1pLUwxEnFPwMBRcX4r8gQEoq
	 3KxBhGFh+5V4TtUisTBudC0QX0xsEPr3CMjsKPjfxHkZdptRRWOaX+Bh8Jr//SdvOo
	 Iqs1jnp+VUTpbEvXkzHlNxP5ZmPQiCVX45gwUp8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 50/60] platform/x86: hp-wmi: Add Omen 16-wf1xxx fan support
Date: Wed, 10 Dec 2025 16:30:20 +0900
Message-ID: <20251210072949.113616837@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit fb146a38cb119c8d69633851c7a2ce2c8d34861a ]

The newer HP Omen laptops, such as Omen 16-wf1xxx, use the same
WMI-based thermal profile interface as Victus 16-r1000 and 16-s1000
models.

Add the DMI board name "8C78" to the victus_s_thermal_profile_boards
list to enable proper fan and thermal mode control.

Tested on: HP Omen 16-wf1xxx (board 8C78)
Result:
* Fan RPMs are readable
* echo 0 | sudo tee /sys/devices/platform/hp-wmi/hwmon/*/pwm1_enable
  allows the fans to run on max RPM.

Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20251018111001.56625-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 9a668e2587952..e10c75d91f248 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -95,7 +95,7 @@ static const char * const victus_thermal_profile_boards[] = {
 /* DMI Board names of Victus 16-r and Victus 16-s laptops */
 static const char * const victus_s_thermal_profile_boards[] = {
 	"8BBE", "8BD4", "8BD5",
-	"8C99", "8C9C"
+	"8C78", "8C99", "8C9C",
 };
 
 enum hp_wmi_radio {
-- 
2.51.0



