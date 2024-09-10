Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7360A188A0C;
	Tue, 10 Sep 2024 10:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963012; cv=none; b=WJlOGpOdP1cLmnrki2gjsqLGoo2R8PCszyWiQmtOox+DTxSUuEelL4hzB34rGgyvMXghYG0OT3RRK+4oGT3Dt7UMbIwir/INWmUBSXvqCU5DIxYD4yKaazsBjECzpBz13GMsQY3KzYu4GMs8h7XMbCThgGHI0gTwSuioUsZOeGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963012; c=relaxed/simple;
	bh=90z/axrDm+hkA+qL82K3ImBkMnA/xhvQ07mXmNiksJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hj5De4WJkYkqTcUABo4Bhm4Ih3QR5zpojISIVxUKzEJrtJQ+1kne5D2OPMsSv96GVUoLfD9uOm8PW3bPVbiHNQ0LQRBI+YbeY3zqiB0E7lJn9NdrNyCNDFVSiNBR/KSuHQAMwxM9KqgvyqifWovdJ/fHQPnDX5sKul5o1fGDL7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxOsIm40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxOsIm40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB218C4CEC3;
	Tue, 10 Sep 2024 10:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963012;
	bh=90z/axrDm+hkA+qL82K3ImBkMnA/xhvQ07mXmNiksJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxOsIm40Q5Nnsb4CLfHxNTAnrQN0j8peQNFuwd8yivxPzi0QLkVvB4/ouuWwnRd9s
	 r9+vQpsOQJc7JEDRvJM/H5sxZ8fZX9XEBMV2g9UcUE67mk11lPjXjLPghj0JRnDzKU
	 l7xrWDD43XawXfoDxbhS+DNXtGCXJQz1ZrlX3Vo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/192] regulator: core: Stub devm_regulator_bulk_get_const() if !CONFIG_REGULATOR
Date: Tue, 10 Sep 2024 11:31:42 +0200
Message-ID: <20240910092601.196677355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 40c80c844ce5..60bc7e143869 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -487,6 +487,14 @@ static inline int of_regulator_bulk_get_all(struct device *dev, struct device_no
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



