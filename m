Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF7D1A254C;
	Tue, 10 Sep 2024 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963266; cv=none; b=D45wJIW0Z40CWIrhhuzm4qU1A539t8fZWi997wMbj2tT6zWIuq5EyCnNZu/FG/20o4zfBsx8RMRP5f39efkx/Y4dE+0HOu0YiZz/NGXvTNTq0K2VSYPdmRd2qKeHUyfRoV/dlewwS/S4pn8SauTEKPys6aIsf9AD+dqz2bGP/AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963266; c=relaxed/simple;
	bh=nxyAKHbbOVazgTXg7KHyYv7QbXFSTSDKhKFgkxDurLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibsXnWhGX9gNkesUUSPgkuy3PS5k0vojIWC1m4dT574NtBZ84jCrRvg7w9hBprHEHFhei347lSIt1t03M3dEiFfz2TwPzqnRcRzfOSdT6/c/NqfUNxzMELaHy+m2gX4IcdeI7eLccYDOg1gScpF/QKnm+5LU9PaznhxqM3bhjdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcBnbWjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcBnbWjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4276DC4CEC3;
	Tue, 10 Sep 2024 10:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963265;
	bh=nxyAKHbbOVazgTXg7KHyYv7QbXFSTSDKhKFgkxDurLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcBnbWjh/IbIrphi16UgRrFCAoe4B4tFdusm5DVRR49f6Ks4wB8AYAyhnWvfyBO66
	 MIC9XSqQb/+IUtoF2/ALLzwxqEqNIuDI7bDpIIN2RapeeBfSEFqwWqAIExctRLF77d
	 4HvJI5z17XZjSVeiMetFmrXl+GxqUjfKIIaA7h44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Wu <wupeng58@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 191/192] regulator: of: fix a NULL vs IS_ERR() check in of_regulator_bulk_get_all()
Date: Tue, 10 Sep 2024 11:33:35 +0200
Message-ID: <20240910092605.650755078@linuxfoundation.org>
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

From: Peng Wu <wupeng58@huawei.com>

commit c957387c402a1a213102e38f92b800d7909a728d upstream.

The regulator_get() function never returns NULL. It returns error pointers.

Fixes: 27b9ecc7a9ba ("regulator: Add of_regulator_bulk_get_all")
Signed-off-by: Peng Wu <wupeng58@huawei.com>
Link: https://lore.kernel.org/r/20221122082242.82937-1-wupeng58@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/of_regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -767,7 +767,7 @@ restart:
 			memcpy(name, prop->name, i);
 			name[i] = '\0';
 			tmp = regulator_get(dev, name);
-			if (!tmp) {
+			if (IS_ERR(tmp)) {
 				ret = -EINVAL;
 				goto error;
 			}


