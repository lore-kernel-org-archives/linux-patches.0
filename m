Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03593BD240;
	Mon, 23 Mar 2026 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282853; cv=none; b=UZqg9zo0ZT/iz8E1VJaEr6/w1iq8dEbtkKBABZbP6GAXobvcqJmTLpF51k9bCV6oUjzF4mY4JML1q+vnovpxiMJfBCjE+/EjZZmZL1hepf3DknjxOgfndr97EC7Cau8/A7wOiIT5jb/Mig7Nx4JPJPW822WPs3WdmD0kIyCtEAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282853; c=relaxed/simple;
	bh=a0WlojgjZjYdwZTEygtY3sOItUkuwFS2osDvmfcX+50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KltudXepKYEmhzyiYITB065eZx1NwPs7I5MZCN+kkNJA6quzfKzV0/ZsWt7lE32SAjsR0RvDpnGvzwevFcgprVIiRWmrqllalRkGGc5tAG7uxU/kl8CucILd4qmeofaEGO2QY3C2mY1wnUcPDqlqjnZC+vXfFJPo/IZLMF3UulE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+xRAw4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+xRAw4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD47C4CEF7;
	Mon, 23 Mar 2026 16:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282852;
	bh=a0WlojgjZjYdwZTEygtY3sOItUkuwFS2osDvmfcX+50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+xRAw4Lu755PjWNsdw9CAHB/BpJ9JoQBUh+PK1Nwq8VKup6OUtSZO2xGPweHDAIg
	 SOyGzlMMiUUnFK2doa8EZtnujRv/rvNb8QkOdPdfpF761CYeOBYAPG1+QJblx1bZ6Z
	 o4FGL22f1DNlAoHqq+55TCFDtKyef9xqEreNjkaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 309/481] drm/amdgpu: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 23 Mar 2026 14:44:51 +0100
Message-ID: <20260323134532.637643194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
@@ -3439,9 +3439,11 @@ static void si_apply_state_adjust_rules(
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


