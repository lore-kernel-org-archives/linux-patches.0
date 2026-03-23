Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8CD3AA50A;
	Mon, 23 Mar 2026 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274146; cv=none; b=F6gbHGZnWRFabOzKYaEaxvXjl4tuKJK9ZYhWWcjTO0HjKtQeLmhirFFRwyJLMUcVndWCPhY1Xfk4WeMYFWVEAwWy4HctuTsLkD8C2cf1cSf+IooAwUQCms4BC34l6Gdp1uIHUd8IiYqr8PZZVeClNmS8eqXRjeobCC8tSTX+3lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274146; c=relaxed/simple;
	bh=RiuP+Kz9Ztdo2sGxbEbgA0R44Sq0ludDoj9F+fHC7nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIsq/0bRHXYZrM8+2HVReTiTAI3aQePRw9nwnZSWy8WoTWS34dWlC/+4GEImblftK3Bw3YX5hii5+e+Y0rZJavFw/l6RCubrLuoS4zLgmgYfujeMB+S6cJywMp9o6TWM2njaD57oyWn23KZD3GQ2J4Ey0ezPBq7EEQR8uVC56qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxi2oYMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxi2oYMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09468C4CEF7;
	Mon, 23 Mar 2026 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274146;
	bh=RiuP+Kz9Ztdo2sGxbEbgA0R44Sq0ludDoj9F+fHC7nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxi2oYMRSfjQIT5ZqoerIvIzd/7+lE5i7Jxa6ytvOoia+AnQOWyf9Ab58uan0S5f6
	 p/R4+HNmrXDowjNRuDNw9jKYSe92fcbZjneS6nirdujoQcuuITri5v8jNnm/sYzS/A
	 fwcStj6F3AKmuDPUktc/LgGZ/0FueQIHunsaRcxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 082/220] drm/radeon: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 23 Mar 2026 14:44:19 +0100
Message-ID: <20260323134507.186324773@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 86650ee2241ff84207eaa298ab318533f3c21a38 upstream.

They need a similar workaround.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1839
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 87327658c848f56eac166cb382b57b83bf06c5ac)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/si_dpm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2915,9 +2915,11 @@ static void si_apply_state_adjust_rules(
 	if (rdev->family == CHIP_HAINAN) {
 		if ((rdev->pdev->revision == 0x81) ||
 		    (rdev->pdev->revision == 0xC3) ||
+		    (rdev->pdev->device == 0x6660) ||
 		    (rdev->pdev->device == 0x6664) ||
 		    (rdev->pdev->device == 0x6665) ||
-		    (rdev->pdev->device == 0x6667)) {
+		    (rdev->pdev->device == 0x6667) ||
+		    (rdev->pdev->device == 0x666F)) {
 			max_sclk = 75000;
 		}
 		if ((rdev->pdev->revision == 0xC3) ||


