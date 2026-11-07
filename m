Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063980;
	b=I364b2dYNYQS2DCFQ2qwh7RgLV+1IBul2kNJEuE85rEVuFuZzkNI1cPsyk3X0uwVgBrF
	 SY8PI69PyqwtFT/GYN1Rl6V7DwNZhlf9FTqcAUmynSHGuf0aHt0T4dG+VmDf7fKPbpaQi
	 uHvzsnfsohVOGjRb2rZFSVFXazR/8WK8+L7JbEamWsLMhhy3oURbi5SkRx5T1l9QIWwVB
	 W1wKuwHUqtwyLl6oUSZkqW+fZeaC5VzsYeoTuy7r0j1Zd7LL92Rrf5mvdr0DfgvihSpV4
	 vfU6daVsKy+RZnG+ZcaL07uiue9bzfICqgzXhMZ2wu/n8ZvDN9E0J5Hx0KTfAXHr+iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V/JXs5Z/6KXaheTW/IVXj+G5K8lXxekVGjKZG3VDiog=;
	b=VtUzuIi41sapOVZ2f1wAuCtJge6uSme6kWdFXW7/80yyYktG2uLg8i/r3RiV3hS+DyfP
	 PANmE8amqrnT7nKSg58XraPjK02vNafDEXOnHPj7Ad5BgrYp3flvRKGxY1pRtaaAboFR/
	 irNczRovar72/h3R7Tat1ApOM2sfIeKhZB867IoHr958SD3LA0hyIUedPtzaKAsYprwTO
	 yJtgagH/UmEoV8fzbM7I7IqzAE+DPXv3SB/PUtYEZv1KcsdEIcagp6JPWRXHi619lFNjD
	 X2kRBQfF6foBmjEYXrOad6z8PP0lwr8RgQsS/2jVCEVIVHKX/dvg+rahEvnWPM5xRPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fl5q7CK4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE0B60A2603;
	Sat,  7 Nov 2026 15:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fl5q7CK4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3833D1F008A1;
	Sat,  7 Nov 2026 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063980;
	bh=V/JXs5Z/6KXaheTW/IVXj+G5K8lXxekVGjKZG3VDiog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fl5q7CK4EY+RtS9vSPx/1FttA2hmG1gQGtJSS8jiyz8rliJraVA15YDYx3pPm2smK
	 R3jLE+duzX8bE8zGJDr9mSwoNCAUdftsh2CZgDjRoo9kQOmp2yzAc7zA86lsS+YwY7
	 pjPnty/BrY+W9yupiVU1bwcZYdsZeDQWFyRQkwRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0163/1257] ACPI: SBS: Fix NULL pointer dereference on allocation failure
Date: Sat,  7 Nov 2026 08:40:59 -0500
Message-ID: <20261107134943.834644697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 2b30842e52d9a364428b598f5edd4b12fa772f5a ]

acpi_sbs_probe() jumps to the common error path when kzalloc_obj()
fails, but platform_set_drvdata() is only called after the allocation
succeeds.

The error path calls acpi_sbs_remove(), which retrieves the unset
driver data and dereferences the resulting NULL pointer when locking
sbs->lock, causing a NULL pointer dereference.

Return -ENOMEM directly when the allocation fails, since no resources
have been initialized at that point and there is nothing to clean up.

This issue was found by manual code inspection.

Fixes: 9460eaae2ee42 ("ACPI: SBS: Convert the driver to a platform one")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260912113355.644238-1-lgs201920130244@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sbs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 86b7c79758526..4b84b3cd11e38 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -639,10 +639,8 @@ static int acpi_sbs_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	sbs = kzalloc_obj(struct acpi_sbs);
-	if (!sbs) {
-		result = -ENOMEM;
-		goto end;
-	}
+	if (!sbs)
+		return -ENOMEM;
 
 	mutex_init(&sbs->lock);
 
-- 
2.53.0



