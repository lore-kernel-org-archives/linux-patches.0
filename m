Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966C91FCFEF;
	Tue,  3 Dec 2024 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240142; cv=none; b=dmG2LF3IJ0sNu6DSTl23mP3u21OzCifc9Aa59GgoanCFGO5Vtg02Sk/Bk84PvJTMlUg0nLfCCFjcLZT7rDGfwrdwu2tV7YcnqdcTOY8a5+vbwz2H6KNqgmAcSDiqzD1XK9cdj+W4Qsp3CTRQaRX6C5qcwu7ZVbEkKwJdSvtSd0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240142; c=relaxed/simple;
	bh=GwDdxsrwgjMFuP3o1lhGwvmR3kNsmCz6j06TUOHIemg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuhXJFzGu11hdtozxQm6rpsUNMyk5TUqPy/j7X8rL5sLs+nhLWYuPt/FaFWi4ePltFb2lHFLvdKm8VnttkbyNZbCHcpk19rQ3z7C9Lrp2w4moUOyjGMFeVkJ14yv98KzxfvVoFOgjA+c/Dz3+tXPdGPXS73CepidhvBSE7KY93s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdsCi4jN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdsCi4jN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FE9C4CED8;
	Tue,  3 Dec 2024 15:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240142;
	bh=GwDdxsrwgjMFuP3o1lhGwvmR3kNsmCz6j06TUOHIemg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdsCi4jNFKw2KKZvOvMs+JV+jU/HAW7f9sA34rDCXzltH/ahpRTgA7Y+vO2vnmtuO
	 otteUYqnTGpUkWxKgIT5ZqFc+7LPGV4Vginrr+liFc3iWa8Q3+rSVWIKlS4pGM/nk6
	 wcFiDwzq4rRnbNoL9LfdQNlokIFpk/4lYsWsj/Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/826] kselftest/arm64: hwcap: fix f8dp2 cpuinfo name
Date: Tue,  3 Dec 2024 15:35:35 +0100
Message-ID: <20241203144743.770801781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f2d6007a2b983..7e95ba5fd4962 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -490,7 +490,7 @@ static const struct hwcap_data {
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



