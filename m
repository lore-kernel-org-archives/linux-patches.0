Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234AC1C0DE7;
	Tue, 27 Aug 2024 14:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770366; cv=none; b=HZOPVf2HgJuqosX02CslAmGYd3KSgitLwGzwbH/xnGooF2pCtIoUwDR15D4ZUhHf26Ixd0/9LH97ktDZ4t6N0/E1LVZL5EP0rUEOKeuxFbUueT8teHrAlEtPWMDTjRljEW5B3b6QL+ix6QwMzeOSDkmYv96VrxQx5D6zx8EwgpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770366; c=relaxed/simple;
	bh=Yae9FylSBRUmx17pQOrgYqAvHe7VRaoyxaLTqsEhscw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oiMuOc0rFd4e9ofW/UCA2JQpa7PjeQzLuMIDlO7oTw5sgwb2tCpPiR7AC4XS5GEWx1alEwi1k1h+qrQyUzpb75VYyjqu7UBpDMvpWuA1MzZWFBS8dHaTcDlj3mSHa2G8jRth75ihzea84QHgw4fbNX4nxdIM95wdpO0fg4oPY+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7eUjIUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7eUjIUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2215AC61042;
	Tue, 27 Aug 2024 14:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770365;
	bh=Yae9FylSBRUmx17pQOrgYqAvHe7VRaoyxaLTqsEhscw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7eUjIUezjT32FuxdcbM7zuhdO4DLO5hKYWw3SJoUH0s0z6U91a6szaOOV4YiHlIF
	 qFaVZmrRDqx/xGkXZzNjZ72HgUS1BHYyVkg1Zabp4S6HCBILijgpMxsJ7CG/FZ6NJN
	 BWBbG/oazbc6tB8uYkgXo/TGW+akx21QqFY016wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/341] platform/x86: lg-laptop: fix %s null argument warning
Date: Tue, 27 Aug 2024 16:37:18 +0200
Message-ID: <20240827143851.290399923@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a1e27334cdf54..78c48a1f9c68a 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -715,7 +715,7 @@ static int acpi_add(struct acpi_device *device)
 		default:
 			year = 2019;
 		}
-	pr_info("product: %s  year: %d\n", product, year);
+	pr_info("product: %s  year: %d\n", product ?: "unknown", year);
 
 	if (year >= 2019)
 		battery_limit_use_wmbb = 1;
-- 
2.43.0



