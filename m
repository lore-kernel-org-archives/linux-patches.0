Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7114C19580F;
	Tue, 10 Sep 2024 10:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964208; cv=none; b=buvnEtbCKMuz8jvl/G5HUhP4Trxu+l4an/KGGpPQoUMC8fJD14kMQ2/7zZySs+x0jh2NEa0bsCMWuxA8dRS6P89of1Ky7Npg5rI09LG20uRg20ZV5I9DHD5JzUXCX/8VXYELhzVanEBrHfxoXdRIrWDTj0oxGb5ok1X8PxUmd4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964208; c=relaxed/simple;
	bh=oqulEuBF1LUunxL4Ktm12n1f8/fAJ0Q+NAwI1zSbXbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4vFv1K/Xt5HhoT0EYbzh45tIl4xwZI9SVoaeYK/ROLXUCEeMicKg7awNU3Ynl56k8nWnDpJ8zK0YEk34J05rsG4a9W13ksBJKgvh/Y46Fs0xKn7OUTQUYbkK9AfLUtsV5rItWS0vCKaZvFCQFlGuSB2de8j1vdN6BODV2+Q0yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7hAETbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7hAETbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC5AC4CEC3;
	Tue, 10 Sep 2024 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964208;
	bh=oqulEuBF1LUunxL4Ktm12n1f8/fAJ0Q+NAwI1zSbXbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7hAETbD3SEiQ5W4bIiToFeHdTUX6JgdrlBKdfNyocuFgLPzkrzch9nt/W+avQjg1
	 JdTB0UgD1EPUMp+XcyXZzRSpsGDE/4R2ZeokjCDTqNjC9eFtr012IrKiqOyhmNTWjK
	 DrFf5NWYGea/jN4kZE8iC7NgW0tDogBFvrTPuwTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/269] regulator: core: Stub devm_regulator_bulk_get_const() if !CONFIG_REGULATOR
Date: Tue, 10 Sep 2024 11:31:32 +0200
Message-ID: <20240910092611.954552887@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 1a5caec7f80ca2e659c03f45378ee26915f4eda2 ]

When adding devm_regulator_bulk_get_const() I missed adding a stub for
when CONFIG_REGULATOR is not enabled. Under certain conditions (like
randconfig testing) this can cause the compiler to reports errors
like:

  error: implicit declaration of function 'devm_regulator_bulk_get_const';
  did you mean 'devm_regulator_bulk_get_enable'?

Add the stub.

Fixes: 1de452a0edda ("regulator: core: Allow drivers to define their init data as const")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408301813.TesFuSbh-lkp@intel.com/
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20240830073511.1.Ib733229a8a19fad8179213c05e1af01b51e42328@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/regulator/consumer.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 2c526c8d10cc..25d0684d37b3 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -489,6 +489,14 @@ static inline int of_regulator_bulk_get_all(struct device *dev, struct device_no
 	return 0;
 }
 
+static inline int devm_regulator_bulk_get_const(
+	struct device *dev, int num_consumers,
+	const struct regulator_bulk_data *in_consumers,
+	struct regulator_bulk_data **out_consumers)
+{
+	return 0;
+}
+
 static inline int regulator_bulk_enable(int num_consumers,
 					struct regulator_bulk_data *consumers)
 {
-- 
2.43.0



