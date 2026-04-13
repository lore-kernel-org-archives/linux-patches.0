Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9295E3016EE;
	Mon, 13 Apr 2026 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099785; cv=none; b=a/qjG4n9TDdoPs9SIgpMkvvV1a4tWtlyvQ4rh3n1Cu89tW5gnjmHJSpxPT8DI5qspw/fLDr2XkCuFAFSNjsIEDxzPr3Fm7/86Z+hPAan0IBHQbLUIO5zmD+n/IovwGdcd1GcwOFNmhQ+PL2xDbAlscc9E1KfDu7jzX4Q+9Y+7BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099785; c=relaxed/simple;
	bh=QekeWKVDftf154vdjRb7xRHS7XAx6p7AKt705X0OXsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8diqIoK1xrEDLVz3n1KLWy8oYZ36Eg7dm+Jemf4VhSDQKKVsDJi2hV5z81Vr+5Zx9QBu6VmMifgRugXrCxEIj2dlrS5mIT1ve9WumJAQk/PWOwrjr61iNOqJU9+dvzb+YOAzm0PPUXXiEEHj6gAT4IT3vC4vuhrUdI4cOwTCxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13/CGjZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13/CGjZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD5C2BCAF;
	Mon, 13 Apr 2026 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099785;
	bh=QekeWKVDftf154vdjRb7xRHS7XAx6p7AKt705X0OXsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13/CGjZF75X0wb1MDCcwBgsZBNwctBuETw8vn0kA99NqfNiPvM8sqgcRrYb+Yr26/
	 hHJ/QTSCMGiocsXX5jzB64sQHoN73JAORtygxg6NcDwJQKOlG2/dZQCfgYpOfsTMZa
	 lx4gwXHmbAx/Kz+mDTLe393ApyqgkDJOzduBwfoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 473/491] mmc: core: Drop redundant member in struct mmc host
Date: Mon, 13 Apr 2026 18:01:58 +0200
Message-ID: <20260413155836.755543338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 951f6ccfcbb7e4a18bf5fef1fb373d21e5831957 ]

The Kconfig option to use the blk-mq support was removed in commit
1bec43a3b181 ("mmc: core: Remove option not to use blk-mq"), but forgot to
remove the use_blk_mq member in the struct mmc_host, let's fix it.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20210202101924.69970-1-ulf.hansson@linaro.org
Stable-dep-of: 901084c51a0a ("mmc: core: Avoid bitfield RMW for claim/retune flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmc/host.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -409,7 +409,6 @@ struct mmc_host {
 	unsigned int		doing_retune:1;	/* re-tuning in progress */
 	unsigned int		retune_now:1;	/* do re-tuning at next req */
 	unsigned int		retune_paused:1; /* re-tuning is temporarily disabled */
-	unsigned int		use_blk_mq:1;	/* use blk-mq */
 	unsigned int		retune_crc_disable:1; /* don't trigger retune upon crc */
 	unsigned int		can_dma_map_merge:1; /* merging can be used */
 	unsigned int		vqmmc_enabled:1; /* vqmmc regulator is enabled */


