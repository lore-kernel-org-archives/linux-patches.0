Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D32B2556E;
	Sat, 14 Feb 2026 01:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031195; cv=none; b=SLGYWsMnlXNniCBQHBtDTXWkMQhnITIqUFWhZwiI5XTz2m1cKA9o9pyyWtf2TB1ZrwmessEEOPvFk3bnL8vAoIRYxrn6sYKgBKBHb4RiWRL3hOL+bPBxwEsWNdJHuEFglILMGyn7rOmssHS1GS2X1Be9peoUOgfPFQGCSNP9rTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031195; c=relaxed/simple;
	bh=5MTZtnzkedgZ3U6h/KR93Aul4jJdN2An+zqK1rv4ZZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLDekAFu09jX0pH6AGqRjr+0fC2929HLRWV5ohGMT0oaeGCBk9rDzqu4Xhco1XeGFLvOu37d+BKKPE4yeUhMbx0m3Cei6VxmPWPY2GmXm40nuQ6rf9gCGfw0ncKndOSF0Bi5OZCeevFBQj5+U5AGpoT4td/lMLZwjJfuhrLBHG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXr60MeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXr60MeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3E5C16AAE;
	Sat, 14 Feb 2026 01:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031195;
	bh=5MTZtnzkedgZ3U6h/KR93Aul4jJdN2An+zqK1rv4ZZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXr60MeMrIYmtCUiVhSl7o7L4axfXBrlOefJRPtdEs1VaFbcHX1n7hsnTZBFLN5NU
	 zLxUPOw4Wpy3524+rr24+lk24PXsj5m6Tcf1u7h9jDvlfk4mtllw1aKKUw/rGfMlIR
	 oEunUz2WWVJ9QKZQxx62hc3WQ0sRGYadU0CjxFd7g3jbi+lnDGdA1nV2xp4rXI3nwO
	 XhkmBpSnNDCtr2BbBXR1i6e8QLxOG+CIxWZnTm2hWB2yxYS5ccBYyDsUcKlzQr4LWG
	 wEESaQX6DDpkO9G7X7msOsmLOR+fz3++IlDAlkXoNQFhfC1vJ6Czmycq2kPJL2tCts
	 PX5ZHhq+LoGjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <gu_0233@qq.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	kcfeng0@nuvoton.com,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] hwmon: (nct7363) Fix a resource leak in nct7363_present_pwm_fanin
Date: Fri, 13 Feb 2026 19:59:37 -0500
Message-ID: <20260214010245.3671907-97-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit 4923bbff0bcffe488b3aa76829c829bd15b02585 ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In nct7363_present_pwm_fanin, it does not release the reference,
causing a resource leak.

Signed-off-by: Felix Gu <gu_0233@qq.com>
Link: https://lore.kernel.org/r/tencent_9717645269E4C07D3D131F52201E12E5E10A@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The driver was first included in v6.13. This means it's only available
in relatively recent stable trees (6.13.y and later, if those are
maintained as stable). It won't be applicable to older LTS trees like
6.6.y or 6.1.y since the driver doesn't exist there.

### User Impact

For systems using the NCT7363Y hardware monitoring chip (common in
server/embedded platforms), this leak occurs during driver probe. While
a single leak may be small, in systems with deferred probing or module
load/unload cycles, it can accumulate. The fix ensures proper cleanup.

### Conclusion

This is a textbook stable backport candidate:
- **Obviously correct**: Standard `of_node_put()` pattern used thousands
  of times in the kernel
- **Fixes a real bug**: Resource leak on every probe
- **Minimal risk**: 1 line addition, correctly placed
- **Small and contained**: Single file, single function

The only caveat is that the driver is relatively new (v6.13+), so the
backport only applies to recent stable trees. But for those trees where
it applies, this is clearly appropriate.

**YES**

 drivers/hwmon/nct7363.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct7363.c b/drivers/hwmon/nct7363.c
index 71cef794835df..47fc1b4a0f3f9 100644
--- a/drivers/hwmon/nct7363.c
+++ b/drivers/hwmon/nct7363.c
@@ -349,6 +349,7 @@ static int nct7363_present_pwm_fanin(struct device *dev,
 	if (ret)
 		return ret;
 
+	of_node_put(args.np);
 	if (args.args[0] >= NCT7363_PWM_COUNT)
 		return -EINVAL;
 	data->pwm_mask |= BIT(args.args[0]);
-- 
2.51.0

