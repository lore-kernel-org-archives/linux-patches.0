Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99812149DE9;
	Tue, 25 Jun 2024 09:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309407; cv=none; b=iZLOk8xjLnva1Rq56K/o+DB1FmvRs95p/JEDkzAUEHRyrOBp4Ccu4pWss8DWXlwgEXI5UlZDNURsHVtti98ZAUh8PQTxLnZNSkLNIMZUSKtgg4FgxuNhKu8Ivv0vZSKhUStdeLDxSlKHB4g6JkphQIy1HpL7nk5WvNct5kN4cL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309407; c=relaxed/simple;
	bh=3/7Cw3VKhEZkPqYSyxX3C2MUXS/dkjRZ6HyeaTR7Q5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0ACHJmZb3JAmlTkvchz168KOqqXPw3Y8DUrc8228yXV+4RPxg/11Em+/h/L2o/pMd16hjDM7ctSzbbAZzmeyIGfgXHuRF8OLnn3Aclw17LBWAUlQv3cTIQ1P0+QLprtzF4Xgq9KKHJOWkWn6A4QF2H31GZUKqRL+a76Lvk1YkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mB7Z5wec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mB7Z5wec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBD3C32781;
	Tue, 25 Jun 2024 09:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309407;
	bh=3/7Cw3VKhEZkPqYSyxX3C2MUXS/dkjRZ6HyeaTR7Q5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mB7Z5wecAxbCM3o6BDUXulCvRhpGsbb46X7EKmFpMfov9FXMRtapR9O1hJ2JRV41L
	 zXDd6TNmIW86nzn++UxAp0IN2MsOXZHzSbUgjki6+U35AhCwaBp8MKQ7o5I4Cv2R6I
	 aZkVM+Gm0aU1EPFJP3iWfE7QTilNNeVg62FtJWpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 188/192] ASoC: Intel: sof-sdw: really remove FOUR_SPEAKER quirk
Date: Tue, 25 Jun 2024 11:34:20 +0200
Message-ID: <20240625085544.376215624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 0bab4cfd7c1560095e29919e2ebe01783b9096dc upstream.

Two independent GitHub PRs let to the addition of one quirk after it
was removed..

Fixes: b10cb955c6c0 ("ASoC: Intel: sof_sdw: add quirk for Dell SKU 0C0F")
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240426152123.36284-10-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_sdw.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -443,8 +443,7 @@ static const struct dmi_system_id sof_sd
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0C0F")
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					RT711_JD2 |
-					SOF_SDW_FOUR_SPK),
+					RT711_JD2),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,


