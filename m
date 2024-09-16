Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E613155391;
	Mon, 16 Sep 2024 12:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488430; cv=none; b=HdhByHFyVQsph96LoF/nDBwpbalGVf9D4CLzxZD2TRHZ1kCsmWfTL/V5EPsEoSqvXANVARlUh3GhhxJutMexL40QPA10SOyRFPOBerGUzT6MyQrCIP4wv2bX8xth5WBaEUKQMm80E7Uwh5QS8usNquFlgZtuXkbNjdYi7dWqn1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488430; c=relaxed/simple;
	bh=/Gz2xbGo9qPj5pTUjI6BA+P1A5CV6WPgdSGYlsP4Sw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BEEngDDgi+mGZIrDLR3NXdY/EUPPnknnrPVudoZ8YWdrY5GG1O8Xk+S9EYf9psa55ynpabDyRY6WAfrTwiJE6Qc4uIqw/BlEOyePINXKh181rNy+L2TrTOrEInlx5BRUwvi8rPXUjvIrawYVvi8FzEqWJMjsH1VPoSUzPC9qoUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJMymwBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJMymwBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB14C4CEC4;
	Mon, 16 Sep 2024 12:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488430;
	bh=/Gz2xbGo9qPj5pTUjI6BA+P1A5CV6WPgdSGYlsP4Sw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJMymwBGLaxme/FKQIayioeTKYN6K8fjTyreWYSWvvbkmBD0iJnW2XNRcm/AA8DWX
	 /iV7PEAb1tzwm1532kXdSImfdb5e/1J1xULQxn9YA6kC1tnW9KUooonfPPyooJw2/0
	 sYEh9kHyHF1GcFS12k7yxIWzyAxJH30ACBSL0vJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 111/121] ASoC: Intel: soc-acpi-intel-lnl-match: add missing empty item
Date: Mon, 16 Sep 2024 13:44:45 +0200
Message-ID: <20240916114232.767364357@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit c4246f1fe9f24f8dcd97887ed67d8fcfd91f4796 ]

There is no links_num in struct snd_soc_acpi_mach {}, and we test
!link->num_adr as a condition to end the loop in hda_sdw_machine_select().
So an empty item in struct snd_soc_acpi_link_adr array is required.

Fixes: dd3bd9dc4708 ("ASoC: Intel: soc-acpi-intel-lnl-match: add cs42l43 only support")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20240906060224.2241212-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-lnl-match.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-lnl-match.c b/sound/soc/intel/common/soc-acpi-intel-lnl-match.c
index e6ffcd5be6c5..edfb668d0580 100644
--- a/sound/soc/intel/common/soc-acpi-intel-lnl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-lnl-match.c
@@ -208,6 +208,7 @@ static const struct snd_soc_acpi_link_adr lnl_cs42l43_l0[] = {
 		.num_adr = ARRAY_SIZE(cs42l43_0_adr),
 		.adr_d = cs42l43_0_adr,
 	},
+	{}
 };
 
 static const struct snd_soc_acpi_link_adr lnl_rvp[] = {
-- 
2.43.0



