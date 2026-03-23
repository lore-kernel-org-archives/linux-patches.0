Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D562C181;
	Mon, 23 Mar 2026 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275640; cv=none; b=kcPw8BSPANKsYADlywNichhwJQ0zGBdQ3gppo9wooPCl4VK4xGlRDurH0Ejzegm4ySUdM154nIKp8sFl/v4bo7/z1SkuOB77EYulXjnWLUODF8qgsJ82uSTxW6RpANUTyxOtCR9CYMYFtciSHpVBtVGCq2O/kFTq0ctLdga9Jt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275640; c=relaxed/simple;
	bh=LCPj7eOnIo0XffgYn4RaaR+aQ3nk1MMh3d01ahOLMpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NP8Aq7FnJXZezpVgkpYZkFLkDgdWkTMVqN0ZpeL6vpkA6clURhQJlWJa5eAC3FZATIQrrxiqny5HdMa0gVxc1YkkqCwxucGBf9pI32LAwkSwpyMtUhXhOdBrxJ39nZL0j4Vbm7FYH4x4vAn4uMmzFrZiC0vY/QIMSmfmBN4MBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGx0LDmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGx0LDmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46474C4CEF7;
	Mon, 23 Mar 2026 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275640;
	bh=LCPj7eOnIo0XffgYn4RaaR+aQ3nk1MMh3d01ahOLMpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGx0LDmNjy+IxhjAiYTjed7Lkmc6QesdhXVg38aMQ0Qr6FBHkfK+MdX1Ero/qu0yN
	 X2+UXYRQOU8N8h7MgzjR7pPoWCJoM+EdxVzfF2ZcGv+B+VfsiTELzWNyzegBFHk5Cw
	 uycl37KGkdDxIlIwwOBv4+C4LaGbGXM7/938a20Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 169/460] drm/amd/display: Fallback to boot snapshot for dispclk
Date: Mon, 23 Mar 2026 14:42:45 +0100
Message-ID: <20260323134530.698339961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <Dillon.Varone@amd.com>

commit 30d937f63bd19bbcaafa4b892eb251f8bbbf04ef upstream.

[WHY & HOW]
If the dentist is unavailable, fallback to reading CLKIP via the boot
snapshot to get the current dispclk.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2ab77600d1e55a042c02437326d3c7563e853c6c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -65,7 +65,11 @@ static void dcn401_initialize_min_clocks
 		 * audio corruption. Read current DISPCLK from DENTIST and request the same
 		 * freq to ensure that the timing is valid and unchanged.
 		 */
-		clocks->dispclk_khz = dc->clk_mgr->funcs->get_dispclk_from_dentist(dc->clk_mgr);
+		if (dc->clk_mgr->funcs->get_dispclk_from_dentist) {
+			clocks->dispclk_khz = dc->clk_mgr->funcs->get_dispclk_from_dentist(dc->clk_mgr);
+		} else {
+			clocks->dispclk_khz = dc->clk_mgr->boot_snapshot.dispclk * 1000;
+		}
 	}
 	clocks->ref_dtbclk_khz = dc->clk_mgr->bw_params->clk_table.entries[0].dtbclk_mhz * 1000;
 	clocks->fclk_p_state_change_support = true;


