Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCAD7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E89C4339E;
	Mon, 24 Apr 2023 13:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343114;
	bh=UGtWXl1fEbi6zraoCmAZhWXM/dKdC9Fm6Vfoa0OA/g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqpoQlzQP4vbKkPMge/TYjNKxLoQzY6jdKHtgJOiqCVfplnKHH1Hb6MRqgYzvuA8j
	 BUROknqQxbw5WrxRbrtcBwv5N/5Rd64NLE1ZNV1lmYQscg/PYx7ALPi3kfPZhtuWcG
	 iXImpt+CitgFWO4D3ccbewqn/tuiXGdGNwbf1n2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 082/110] drm/amd/display: set dcn315 lb bpp to 48
Date: Mon, 24 Apr 2023 15:17:44 +0200
Message-Id: <20230424131139.540369293@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

commit 6d9240c46f7419aa3210353b5f52cc63da5a6440 upstream.

[Why & How]
Fix a typo for dcn315 line buffer bpp.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
@@ -222,7 +222,7 @@ struct _vcs_dpi_ip_params_st dcn3_15_ip
 	.maximum_dsc_bits_per_component = 10,
 	.dsc422_native_support = false,
 	.is_line_buffer_bpp_fixed = true,
-	.line_buffer_fixed_bpp = 49,
+	.line_buffer_fixed_bpp = 48,
 	.line_buffer_size_bits = 789504,
 	.max_line_buffer_lines = 12,
 	.writeback_interface_buffer_size_kbytes = 90,


