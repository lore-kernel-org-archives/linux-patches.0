Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000CC1990C4;
	Thu,  6 Jun 2024 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683124; cv=none; b=GsIzSVMKWDOeamchD7iX9n89ahmn7GpUraddwMwWquaQ45V9KSop57h1qnprEPO/ovF2dlowygenrgskHdPw6+EWG9NtpvCtpJK9R3I9mu8R6ctz4Eo6mUCkv1Ah4b+R6Untv9n/yfMrmRG5/9i7MYO9SwyTKRLwuIQ+aq+RQV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683124; c=relaxed/simple;
	bh=ka1EVhxh0Plf8KhVY+vH8UVnE23qnyEi+s7a2cI0GKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpLkt3aXoejVeK0If3qztt4WzSv3rgAgwX8Yxqkuhu1t0mPJb2u+2dcoXeAvDDAtnxbybJ0y6aerXlAhq64g2F9scf9KgcG3b+ve0x2fyzw5iK00IPHsgc8IV+jXPbT5LBsik0374K03kAb9Gfrsy/8YdbS3jurkhce38hwY0Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiTN6x1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiTN6x1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC47C32781;
	Thu,  6 Jun 2024 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683123;
	bh=ka1EVhxh0Plf8KhVY+vH8UVnE23qnyEi+s7a2cI0GKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiTN6x1bqh7cQHZ2AvnWtVX2zsrRGqFcaAR4jHAGlnpzwSZEqkgjaCEVaCHLAw/Ve
	 4kX0LuXf6SkJXRyKTfCR2QMxsTOwZd5+Uleypu63BB479QM1576ehWQ6PZaJagiGpM
	 /xYrIYpoLT0hXW7gmorpZyZSSpw+Fb53j0s0Sunk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/744] ASoC: rt715: add vendor clear control register
Date: Thu,  6 Jun 2024 15:55:37 +0200
Message-ID: <20240606131734.496912457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit cebfbc89ae2552dbb58cd9b8206a5c8e0e6301e9 ]

Add vendor clear control register in readable register's
callback function. This prevents an access failure reported
in Intel CI tests.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Closes: https://github.com/thesofproject/linux/issues/4860
Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/6a103ce9134d49d8b3941172c87a7bd4@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt715-sdw.c b/sound/soc/codecs/rt715-sdw.c
index 21f37babd148a..376585f5a8dd8 100644
--- a/sound/soc/codecs/rt715-sdw.c
+++ b/sound/soc/codecs/rt715-sdw.c
@@ -111,6 +111,7 @@ static bool rt715_readable_register(struct device *dev, unsigned int reg)
 	case 0x839d:
 	case 0x83a7:
 	case 0x83a9:
+	case 0x752001:
 	case 0x752039:
 		return true;
 	default:
-- 
2.43.0



