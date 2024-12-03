Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0936F1F7578;
	Tue,  3 Dec 2024 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237727; cv=none; b=YII1GYjplCnuHd5K2uhMQWqajO932mLW4hOgqx1VgsLHsKcTdixmyxEj8I5bPs56ur+b4kgndkIjI8N3zfEVwVeVdwcHHa7zqo+B4JH3RSGasXcC/dmSl4+NP+yqnbRg2gUVxuIsscOG9Db0ZGesQ9PvBasPVkQZtkzuAIleM4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237727; c=relaxed/simple;
	bh=9S47EnhrD4GH+7GhqQ654OtLGdfBzJhh+hQ8QH7onR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3J4PvRY3oyYYEQvPrxcdnOGUy7lMouWGI9oSYWxn40N04QnRs4MCfHRwFf6xzgNoCmuqP1L979jzt3ofEbv5G8F0ZLi9vbqIDJfJb5cHwBHqObFafV1QbBYwadoejoM3Cu0HYJIlimF2gg0RABnnhNV5qAuLNI7YAUXKdNM3k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxBLHdCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxBLHdCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78464C4CECF;
	Tue,  3 Dec 2024 14:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237726;
	bh=9S47EnhrD4GH+7GhqQ654OtLGdfBzJhh+hQ8QH7onR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxBLHdCrpBygR9I3GdbsTnOrbkMLAE/3k8IQ7ypBmbqg/msN119qBqmUlCzgrrrv8
	 J4sYhMqCJm+uJYwXrF9D0yuh9pY0KSH0afI4j3BSPpaZ8i79xCqDu++lEhayZ8+zWW
	 gWIOIUc/+nWgEn0YdCLwGyKX8/iOGKU5kOT+Rpis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 052/817] kselftest/arm64: hwcap: fix f8dp2 cpuinfo name
Date: Tue,  3 Dec 2024 15:33:44 +0100
Message-ID: <20241203143957.703233446@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit b0d80dbc378d52155c9ecf9579986edccceed3aa ]

The F8DP2 DPISA extension has a separate cpuinfo field, named
accordingly.
Change the erroneously placed name of "f8dp4" to "f8dp2".

Fixes: 44d10c27bd75 ("kselftest/arm64: Add 2023 DPISA hwcap test coverage")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240816153251.2833702-3-andre.przywara@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/abi/hwcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/abi/hwcap.c b/tools/testing/selftests/arm64/abi/hwcap.c
index d8909b2b535a0..41c245478e412 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -484,7 +484,7 @@ static const struct hwcap_data {
 		.name = "F8DP2",
 		.at_hwcap = AT_HWCAP2,
 		.hwcap_bit = HWCAP2_F8DP2,
-		.cpuinfo = "f8dp4",
+		.cpuinfo = "f8dp2",
 		.sigill_fn = f8dp2_sigill,
 	},
 	{
-- 
2.43.0



