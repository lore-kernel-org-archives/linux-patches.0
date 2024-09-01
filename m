Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5FC3BB48;
	Sun,  1 Sep 2024 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210281; cv=none; b=OgMziA+/csNJArljeveWPgKgcf/aOh71YO0JaAyhj3hTMfqJJkhywYgxe0qd0uDhEg1xE8My6gas964agLHIww8Xig5Q9MbKsP3NbJDBy4+ZOZjoV7oOD4c5LhzieWfSSgqQYHqr7QpIO9xw5cv53ARC4jtIt+fZ3D+ekpqzf1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210281; c=relaxed/simple;
	bh=t+fNsx33bHlJ6/gYs/oOwRyDVVOubH7LAP8J86zmJko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b07p64no7vTA9JQYNG7c4HsvDEfCNJ45WQaNZtF7xeoKBIpRRRevsQiVlQNpwI5qip+rADkfSukHe16HKJEPZEbGEv+sTdQO/rrSjsDaZcZkIwITkFipmtmlva3eeUZRn0FdlY9+AAzdQVHTDy/7DeD3LO+TTQ2Ym8vxAo2iRf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFJws2xX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFJws2xX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C24C4CEC3;
	Sun,  1 Sep 2024 17:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210280;
	bh=t+fNsx33bHlJ6/gYs/oOwRyDVVOubH7LAP8J86zmJko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFJws2xXv78dmYezzUVS/xcKdTIPjKfE0GtpavSO6V/UlLArMPAMMTSgtTrAsroka
	 kivrmbHrXhV0purPtN90eJskprnPbnPtHXr+zgOXUAvqu7XnrsNXlvsYq6YUO00kwr
	 yuhInwni65fKM5gvpWEYT+wZg3431JyIZaunDk3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/215] platform/x86: lg-laptop: fix %s null argument warning
Date: Sun,  1 Sep 2024 18:16:53 +0200
Message-ID: <20240901160827.168350095@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit e71c8481692582c70cdfd0996c20cdcc71e425d3 ]

W=1 warns about null argument to kprintf:
warning: ‘%s’ directive argument is null [-Wformat-overflow=]
pr_info("product: %s  year: %d\n", product, year);

Use "unknown" instead of NULL.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/r/33d40e976f08f82b9227d0ecae38c787fcc0c0b2.1712154684.git.soyer@irl.hu
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 5f9fbea8fc3c2..b374b0c7c62f6 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -665,7 +665,7 @@ static int acpi_add(struct acpi_device *device)
 		default:
 			year = 2019;
 		}
-	pr_info("product: %s  year: %d\n", product, year);
+	pr_info("product: %s  year: %d\n", product ?: "unknown", year);
 
 	if (year >= 2019)
 		battery_limit_use_wmbb = 1;
-- 
2.43.0



