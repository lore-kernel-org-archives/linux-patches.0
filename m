Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FF71465A8;
	Tue, 25 Jun 2024 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308804; cv=none; b=MR6frToHApEemBlLx2ppZGbEh09eixBxC9f9aogsgMaBwuNFZKsilCVu3WM0WIRXMmpIwLViPk8U/TVpGzmrg7jkQq2lRx3fZFnlER7IYpfrnL0SC0YRQ9hSuLbUbtsA9qe2RxQfbkDyFPV8Ag2O1EP1Y5JICXEd7bmeVZkbWe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308804; c=relaxed/simple;
	bh=ThUZl5A6RoTZnYz6dDhmQyr/m5A8IAKZFtrdgm2mt2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUJxFjA0alzXPG5Xc8p+vl7vo0HVpZyY64dfPbilRdrDwjjVt7OvmfGXl//Tvwud07xkbsW/OJEbOzbx98pt248NzqbP07u0DMi0VBwdo0ZgcceEwUeSlNkQcO4TnQ3sNRAg+1WiUDx4yyW9tD/JU/5vLaiEN+SUtOfSAK2jL8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oi8++TQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi8++TQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC09C32781;
	Tue, 25 Jun 2024 09:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308803;
	bh=ThUZl5A6RoTZnYz6dDhmQyr/m5A8IAKZFtrdgm2mt2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oi8++TQnwPstMmx3q/J8jXbeui3hUAv1lgnGmu6c5AXyPAhkJmwyhgjsW5RoR1FY1
	 yCSJmDNM5alMj/c6Ur4d1DkvH08a7iG/ByDqCD9F3hZA2tK6Aza3pOYqgNMR9iWQae
	 vvIM8Zc74KEChVVX1LzvF0wo+tdNrJz1mO/4+J4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.9 246/250] ASoC: Intel: sof-sdw: really remove FOUR_SPEAKER quirk
Date: Tue, 25 Jun 2024 11:33:24 +0200
Message-ID: <20240625085557.493272685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -436,8 +436,7 @@ static const struct dmi_system_id sof_sd
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0C0F")
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					RT711_JD2 |
-					SOF_SDW_FOUR_SPK),
+					RT711_JD2),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,


