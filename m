Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5869D145329;
	Fri,  8 Aug 2025 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667062; cv=none; b=D7kSEFiVG3h6VJQNaM7K/cc3bGJ4aGolu5hXJL4zTOirR/y5xudPYg27cYCd0rCDqp6AYFy8qRicomkk+nM6zDlOS+fYlj4DCLL7lmEp2UcwJOEaRT2wFnm4+kVqDS+fA2jghb4E0SwCnkt7fv3eVVchLAFxmg26zX9DpmmGNDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667062; c=relaxed/simple;
	bh=wt0FNFAHEcf0j/VNLa2xVguUWhtRBeXnNUOEOW+wyN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ntpn1UepP2yOwdnWscEYJCmhyzqN4eHCRbQJX3dTvWyOET++6iLzrs3LBjlzo6VlCezEpUZY6cTTSkr0Zy5wOzSugHBtoYnWY8U6Z7g9HhUxo5VIleb1E6na4NuJepSQlO+v07SFE18AphU95qpSWhv6YWt9meCsS75jZOUH7A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PihYqGlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PihYqGlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAE4C4CEF6;
	Fri,  8 Aug 2025 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667061;
	bh=wt0FNFAHEcf0j/VNLa2xVguUWhtRBeXnNUOEOW+wyN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PihYqGlktwwRoha9pks4oShj6KwQF4YV4GmScSxdDlTpYrxvDkSi8gJwQ9XCtqpL7
	 ILcywGWzObhfS0e8q83eFsHfw0wrI+ON4sOMhcM2FSgbwFkceJRPdIo5pUCV7hdpd9
	 mumG59GhHjta5iREjcK1ARvCoTIxMoS0vpdiqNGNJiAYonYa0Je4aDRf3+VLkurEc9
	 eIEfDERovlAtco/0oqJzAMOWkSf/5XPth6qyVwg4nqGz9wdlhXsw+ub5C3Cch2zVtj
	 t/pz2HftufUcWQnAQPudhsLUQV5uj02KJaP4DttKOhEsrd8Soma62/yARLnCMBX8aq
	 7BJcF2tfzwFMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-i3c@lists.infradead.org
Subject: [PATCH AUTOSEL 6.16-5.4] i3c: don't fail if GETHDRCAP is unsupported
Date: Fri,  8 Aug 2025 11:30:43 -0400
Message-Id: <20250808153054.1250675-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808153054.1250675-1-sashal@kernel.org>
References: <20250808153054.1250675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 447270cdb41b1c8c3621bb14b93a6749f942556e ]

'I3C_BCR_HDR_CAP' is still spec v1.0 and has been renamed to 'advanced
capabilities' in v1.1 onwards. The ST pressure sensor LPS22DF does not
have HDR, but has the 'advanced cap' bit set. The core still wants to
get additional information using the CCC 'GETHDRCAP' (or GETCAPS in v1.1
onwards). Not all controllers support this CCC and will notify the upper
layers about it. For instantiating the device, we can ignore this
unsupported CCC as standard communication will work. Without this patch,
the device will not be instantiated at all.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250704204524.6124-1-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the surrounding code, here's my
assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real bug that prevents device instantiation**: The commit
   message clearly states that "Without this patch, the device will not
   be instantiated at all." This is a concrete functionality issue where
   legitimate I3C devices (like the ST pressure sensor LPS22DF) cannot
   be used with controllers that don't support the GETHDRCAP CCC
   command.

2. **Small and contained fix**: The change is minimal - only 2 lines
   changed:
   - Line 1441: Changed from `if (ret)` to `if (ret && ret !=
     -ENOTSUPP)`
   - This allows the function to continue when GETHDRCAP returns
     -ENOTSUPP instead of failing

3. **Clear regression prevention**: The fix prevents device
   initialization failure for hardware combinations that should work.
   The I3C spec evolved from v1.0 to v1.1, and this handles backward
   compatibility gracefully.

4. **No architectural changes**: This is a simple error handling
   adjustment that doesn't change any core functionality or introduce
   new features.

5. **Fixes interoperability issue**: The commit addresses a real-world
   hardware compatibility problem between certain I3C controllers and
   devices, which is exactly the type of bug that stable kernels should
   fix.

6. **Low risk of regression**: The change only affects the error path
   when GETHDRCAP fails with -ENOTSUPP. It doesn't change behavior for
   successful cases or other error conditions.

7. **Follows stable rules**:
   - It's obviously correct (treats unsupported CCC as non-fatal)
   - It's tiny (2-line change)
   - Fixes one specific issue
   - Fixes a real bug that prevents hardware from working

The commit allows I3C device initialization to proceed even when the
controller doesn't support the GETHDRCAP command, which is reasonable
since HDR capabilities are optional and standard I3C communication will
still work without them.

 drivers/i3c/master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index fd81871609d9..e53c69d24873 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1439,7 +1439,7 @@ static int i3c_master_retrieve_dev_info(struct i3c_dev_desc *dev)
 
 	if (dev->info.bcr & I3C_BCR_HDR_CAP) {
 		ret = i3c_master_gethdrcap_locked(master, &dev->info);
-		if (ret)
+		if (ret && ret != -ENOTSUPP)
 			return ret;
 	}
 
-- 
2.39.5

