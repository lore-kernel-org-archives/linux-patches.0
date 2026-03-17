Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FCE3BFE59;
	Tue, 17 Mar 2026 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766621; cv=none; b=RZDkpBP0GzTf9APC7WPbEAn4eK8+GQ/nSvOXF2LwTEfZjUzKL/abq8+dws8ecsKiWNOO7gt9kn1DO9yKGO9hmyoJ6biRbq6DXjjLKEUxnN+OGHme8D7KmCR7HL6kJ3rYbr/IaQmpN+7Olp8czrxYToXwfVEphN04djwZraba2Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766621; c=relaxed/simple;
	bh=pz4XdF/r3uBnabl2eGS0kM8HmiMkgM6NGzoSqEzWiKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV4BsIkIwDnSWtfxz6jK43o6pXc098dHTPhu7PXGYzzhw8fxBsZAAIkxsVIH3lgiURnWZ2XHmrXSZnjubJQ0kRMNS73Zw+xeKitXte4W0rLVtPVgYJKEPKDkUb3tDl8eQQXUH0QwcEZ4fFiKV+StJcWQayehoEyV6wG/3t2nZjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuHR/ugg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuHR/ugg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686FEC19424;
	Tue, 17 Mar 2026 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766620;
	bh=pz4XdF/r3uBnabl2eGS0kM8HmiMkgM6NGzoSqEzWiKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuHR/uggTZbNl+j0JHW1M6mCOxNQ801I6a9d3mh3gYrCmTXjNzRUMEj29JZ/8nzSM
	 u6Kk1+yp33gmcIOr+seBCvoVrOFnYeyZ56CeMNO1/0FXq9UGaGQTZjlvNZGzMKwrYW
	 ikVxcuRhTIM0+nGIIeAjhY69Nx74A28nxuDZtcnY=
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
Subject: [PATCH 6.19 286/378] drm/amd/display: Fallback to boot snapshot for dispclk
Date: Tue, 17 Mar 2026 17:34:03 +0100
Message-ID: <20260317163017.527008891@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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
@@ -71,7 +71,11 @@ void dcn401_initialize_min_clocks(struct
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


