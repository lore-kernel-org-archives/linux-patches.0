Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AA110E0;
	Fri,  6 Dec 2024 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496490; cv=none; b=c9I2jNl1pBEfzPByJlSRVvhGzUDCCeex6snbzQYDF5zRjiYFUyD387i7kMBDSdzCdkGvqKpLmrV8sJR+o74Fg5V1ULkFEKa1Soy/PwU4hXHTxbquNCUWGFjqTCqyuknUTOynmtKSCg3Z1uLfBw9ZKpPy+e4KJsxlewsjeU2PjFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496490; c=relaxed/simple;
	bh=y06kvIziHgVP5AcLqdpAZ8XGfihgeb0CB0VAZOulDXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EM3MMS42SiVuwi8uCXNJcBYf1pWsKP16iJX3rW38l46S5Qxgxp7dNSFdK1Pt2Bwoe+xM55HpQ7ZgS3EOYLA8nXrTVozmiXm3zSoYrP5kpH+vbXIyRLyV0NIu+bdZ6GPvm/BetJ6eGObID6pVecFRnomMyzHnZMmYgA3IxDG8QdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqezboBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqezboBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2181EC4CED1;
	Fri,  6 Dec 2024 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496490;
	bh=y06kvIziHgVP5AcLqdpAZ8XGfihgeb0CB0VAZOulDXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqezboBrQhLctSgzxE5a17igUSgFw3bcxhyQahJMit0upZVzVsGnWn/usNaP5pZPv
	 RhFA+g685E6KwaLpoxatDzooRQ0XStRyMSwd0wbLDYVDN7mxP+J3boFKQqA5KLBvGp
	 wYDrOi5/7nufzrbnFNMEWBnhuSJSTx47ul+xjuKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/676] ASoC: tas2781: Add new driver version for tas2563 & tas2781 qfn chip
Date: Fri,  6 Dec 2024 15:27:19 +0100
Message-ID: <20241206143654.150529714@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit fe09de2db2365eed8b44b572cff7d421eaf1754a ]

Add new driver version to support tas2563 & tas2781 qfn chip

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20241104100055.48-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 629e2195a890b..1cc64ed8de6da 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -2022,6 +2022,7 @@ static int tasdevice_dspfw_ready(const struct firmware *fmw,
 		break;
 	case 0x202:
 	case 0x400:
+	case 0x401:
 		tas_priv->fw_parse_variable_header =
 			fw_parse_variable_header_git;
 		tas_priv->fw_parse_program_data =
-- 
2.43.0



