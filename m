Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063311;
	b=WXovu72alGyD1ouXhJ8l/3EGWfyAk+g7xpQZUDV6oKIVX+l5PmaLh1MCOodb36BFdXju
	 rEiULleOj2rx9EaIl8Anc5jWgCH+6c6joWGvDrQxDL89wMWOMXESi3kow3vY2GdIqjMm8
	 thIHvWXbKSS4zXzv6JEx3ZzHRIKbkuTPO54wLFLt6GmL3zDLKw3zrgAa6ghFqKJbIQY1y
	 YY9wLWMRQPL4Etik30DTqBPE/TKmzT230MFvVu3EIUfRGXYTHjQQsvD0xHhvwrAwP3NZy
	 9pXhZPBeVte9/gsx9hm+6DS6aV9dYN0XMTZ8CdqVY1oYsy7zf44NYEVbSXNFlw4kHqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FRZ8+qaf3UJW61p9zHUgRgedxm9mxsC9ZzLccbnLi8k=;
	b=1TeGyuO50ubJgWh+QF2ozZO0qKpSyoSLN/zU8ttoJgRgqoVqg1zdarJ9YCV+vGY4pRMd
	 wtp1QqLQZ2s8Y5uCnd/kLOqYpR1eo0jSS5Qb/KHrJOqDA50Jba2dCs2sAOaS79WkXUuWb
	 eJKpY4FrZgJ3j9S3bCD85EqXRGQJOkm58GdSx0RgBkraNTAIr6JU8tg3DoQWkAvaw857M
	 5I70S7RNi0owSUOcKHu5j1XjyRrsn9Y71ujhs25dso721kHRJ8MiL8+TkGWafpoKhyIj3
	 C9C6CYMhejDoW2eKIYQsHfoTVmuT0l8/OXEZe/JR9+V9XNx+66shzZ70dXp0EcJhYQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULvi7W8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B061606A33E;
	Sat,  7 Nov 2026 14:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULvi7W8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6791F0089F;
	Sat,  7 Nov 2026 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063311;
	bh=FRZ8+qaf3UJW61p9zHUgRgedxm9mxsC9ZzLccbnLi8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULvi7W8FoP6WPOd+tFdTIpyEJ8Vz5JupQDod9mbYryyrMrc37qz6cUjSLK7fvg75g
	 hr4FoRoLuveN+O2WwsAwULm2B4oYVD7bTvhY5AoXDPa9vstW37mWM+Jde1BwWH7S6z
	 dNIrwD/MidJxJqbyM29ACogbEMNEhhD9rsmGW0hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 499/869] platform/x86/intel/vsec: Fix inverted walk_header() test in get_features()
Date: Sat,  7 Nov 2026 08:53:01 -0500
Message-ID: <20261107134910.562328253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 3678e39c6aaeb9aa380c7357b24f7d55955543f8 ]

intel_vsec_walk_header() used to return a bool that was true when devices
were found. It was converted to return 0 on success and a negative errno
on failure, but the boolean test in intel_vsec_get_features() was left
unchanged, so its meaning is now inverted.

A successful walk returns 0 and leaves found set to false, while a failed
walk returns an error that evaluates to true. When no other capabilities
are present, intel_vsec_pci_init() then returns -ENODEV even though the
auxiliary devices were created, and the driver core tears them back down.

This affects platforms that have no DVSEC or VSEC capabilities and
describe their features through device_data instead, which today means
DG1. Test the return value for success explicitly.

Fixes: a6ce8bf3c993 ("platform/x86/intel/vsec: Return real error codes from registration path")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20261001220351.1592138-3-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 1e292eaeb209d..814e418bea82b 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -617,7 +617,7 @@ static bool intel_vsec_get_features(struct pci_dev *pdev,
 		found = true;
 
 	if (info && (info->quirks & VSEC_QUIRK_NO_DVSEC) &&
-	    intel_vsec_walk_header(&pdev->dev, info))
+	    !intel_vsec_walk_header(&pdev->dev, info))
 		found = true;
 
 	return found;
-- 
2.53.0



