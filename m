Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E2D3AA50A;
	Mon, 23 Mar 2026 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274149; cv=none; b=I6kSorEXOFi+aN2rTgCj0R+Nk1rwXC3GxQHQ9Z5mo7jbNKlsHB4E4Jt+HwANE9/LfQL/ode+hzntRhhKX+o1nmQBhQB8RssoupA25DZZL5l5cng4S64S8eDbOoNgQ7FsLqusxj2XHLA+7hJCgYbx31HxSVt/eFdEhJSwAPYWH+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274149; c=relaxed/simple;
	bh=YpuUOJ727RPsmWq8n4NkEf0pj55IjfqSZwRuziMWZAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ccuy8q/SOzBSHj6f32pcHagQfn501sF2gCymMg2az0id6uzePGjmELp3Bh0+r5oUMZQClSGwlaCLEspU6JFL7aJiAundF1WBCFOqFMEHpU2usOMhA7yxQIMu6MSKBMVqP+aUq1S9wzgkI/IaKjufd3WWmHtAooAe4Poy0zAoeqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKedC+4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKedC+4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4C0C4CEF7;
	Mon, 23 Mar 2026 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274149;
	bh=YpuUOJ727RPsmWq8n4NkEf0pj55IjfqSZwRuziMWZAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKedC+4k45FRQ6Qpda/dddV//+hER0ndI3B9bDYm0/95GgZC3SEfOTy7R3c40rL6G
	 pGwpnM6ySd21AwjBouAOMZUQzsNxhd/y2+UspzLp/Mw23lC1ebEepoiIJu7T1jrl0Z
	 GLHPdKAchaKZLoSaMgSDX0tjXyT3ByO1TXt88dxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 083/220] drm/amdgpu: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 23 Mar 2026 14:44:20 +0100
Message-ID: <20260323134507.218465034@linuxfoundation.org>
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

commit 9787f7da186ee8143b7b6d914cfa0b6e7fee2648 upstream.

They need a similar workaround.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1839
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0de31d92a173d3d94f28051b0b80a6c98913aed4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3454,9 +3454,11 @@ static void si_apply_state_adjust_rules(
 	if (adev->asic_type == CHIP_HAINAN) {
 		if ((adev->pdev->revision == 0x81) ||
 		    (adev->pdev->revision == 0xC3) ||
+		    (adev->pdev->device == 0x6660) ||
 		    (adev->pdev->device == 0x6664) ||
 		    (adev->pdev->device == 0x6665) ||
-		    (adev->pdev->device == 0x6667)) {
+		    (adev->pdev->device == 0x6667) ||
+		    (adev->pdev->device == 0x666F)) {
 			max_sclk = 75000;
 		}
 		if ((adev->pdev->revision == 0xC3) ||


