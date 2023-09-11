Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F51911706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F30EC433CA;
	Mon, 11 Sep 2023 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444259;
	bh=/kpNMW48JpbR8w1YiJc+WFmEQOnM0KPTZTsAjJxjehA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkN1UkIakOXcAPybgQ71NUxIHb/lXutrfbAvOp2YCSIFb5bHp4JbOCynMwigczoLy
	 hU2JfZRcawP+mteYUcPo94Md9QPIcimI+3o5iXIhqePV9Bb6hcjUCHLtKpWUodXEKs
	 MBvsykXwMoN3HXw7Xgwsb7a9dyFDuhF/TYih8bA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Swapnil Patel <swapnil.patel@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 666/737] drm/amd/display: register edp_backlight_control() for DCN301
Date: Mon, 11 Sep 2023 15:48:45 +0200
Message-ID: <20230911134709.148260336@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 1611917f39bee1abfc01501238db8ac19649042d upstream.

As made mention of in commit 099303e9a9bd ("drm/amd/display: eDP
intermittent black screen during PnP"), we need to turn off the
display's backlight before powering off an eDP display. Not doing so
will result in undefined behaviour according to the eDP spec. So, set
DCN301's edp_backlight_control() function pointer to
dce110_edp_backlight_control().

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2765
Fixes: 9c75891feef0 ("drm/amd/display: rework recent update PHY state commit")
Suggested-by: Swapnil Patel <swapnil.patel@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_init.c
@@ -75,6 +75,7 @@ static const struct hw_sequencer_funcs d
 	.get_hw_state = dcn10_get_hw_state,
 	.clear_status_bits = dcn10_clear_status_bits,
 	.wait_for_mpcc_disconnect = dcn10_wait_for_mpcc_disconnect,
+	.edp_backlight_control = dce110_edp_backlight_control,
 	.edp_power_control = dce110_edp_power_control,
 	.edp_wait_for_hpd_ready = dce110_edp_wait_for_hpd_ready,
 	.set_cursor_position = dcn10_set_cursor_position,


