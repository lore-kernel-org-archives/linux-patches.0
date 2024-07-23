Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208E5155351;
	Tue, 23 Jul 2024 18:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759297; cv=none; b=bLN/EObnWbXHpcEHliaz+XHUBaLx09XU0Z/w/anCuTkBglPR/du66PSCKKBf9T5uQl07iINA8wIYeuY8r/J4pvFlhZo/yHhF7cEzM3hEtnsfZg3LcZsZVIcZjbU3964RWkHuJ5zXFgJVGltxnvNIgDSyVlQExfhCzhYgwx4piYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759297; c=relaxed/simple;
	bh=IytkNd6WBVGu/jzGQfEoYxJ+cKrM00kO3NswDDIfjjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XlxcFyiS6c737jlg5wUOg08Y2SxRO/2lkV+NaD9MEOw4qFDuBuEW9HHpcq7xCdQ64Q6JXLQ+9oSc/+RJmBA5o+MllotYbK05KkKUGiashV6uNzAbbos4AYzw36hLIuarWJK7ekLpiigYjT5AtgMe7Ke1Mcw9CgmmTzEfmJ21q2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQ/wr3Cm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQ/wr3Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB1FC4AF09;
	Tue, 23 Jul 2024 18:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759297;
	bh=IytkNd6WBVGu/jzGQfEoYxJ+cKrM00kO3NswDDIfjjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQ/wr3CmdFbUdPWQZr+ppmYHmZ0uBVYQ8v+hj4TaQmqTFIM3lJkdU8fbeANxkDRVh
	 ZNCi1+LHpPo6Hj56VQ25n/adcr/KP5coZyqyM01S1KqgUBYlifzYa3P+6GYCXLxEuz
	 JJlv7y53eSkdRQn50bFFrEtODqsT6s1QzizE1bCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/105] platform/x86: lg-laptop: Change ACPI device id
Date: Tue, 23 Jul 2024 20:23:46 +0200
Message-ID: <20240723180405.904629045@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 58a54f27a0dac81f7fd3514be01012635219a53c ]

The LGEX0815 ACPI device id is used for handling hotkey events, but
this functionality is already handled by the wireless-hotkey driver.

The LGEX0820 ACPI device id however is used to manage various
platform features using the WMAB/WMBB ACPI methods. Use this ACPI
device id to avoid blocking the wireless-hotkey driver from probing.

Tested-by: Agathe Boutmy <agathe@boutmy.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240606233540.9774-4-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index aa063c3c935b5..40051b043c422 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -770,7 +770,7 @@ static int acpi_remove(struct acpi_device *device)
 }
 
 static const struct acpi_device_id device_ids[] = {
-	{"LGEX0815", 0},
+	{"LGEX0820", 0},
 	{"", 0}
 };
 MODULE_DEVICE_TABLE(acpi, device_ids);
-- 
2.43.0



