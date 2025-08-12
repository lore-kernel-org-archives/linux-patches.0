Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D83305E08;
	Tue, 12 Aug 2025 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022218; cv=none; b=Om4D7YAebMmjT/bWb5fHUR52My7RI3oDAQ8W7U8GjUxDTQTEEXUyZH8PaHNH71JsTKBrQ5sob2NerrOjEoTkeyWmtYi2X5wpJzPzkZaLhX419oWT2xnwIKXvunQ4QXGYQ2Io3nU6Mltqx1GymS97eg9kneYBN9P1ivnGz/weWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022218; c=relaxed/simple;
	bh=xxnweZD77CcKJOEuta/z8Fa9y7v48PNsWLt1ayMU5lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYJGtzcfuiwM7XWSSfgDSUI7Y5mS2iBlGmj71xvoA5lMZZsstxhtoQfGtOY6zzrmHNTj7SuXVRKlbJ6GoOmN8stAK3+Hmf+w3x3U76/DavKr5RRGrTVel+6UlG/RsiW0tr7HFC41wzGTt2lhVfe+Hxk4FL0WS1lhCv43NqJjpI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REuvD9VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REuvD9VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CDAC4CEF0;
	Tue, 12 Aug 2025 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022218;
	bh=xxnweZD77CcKJOEuta/z8Fa9y7v48PNsWLt1ayMU5lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REuvD9VMy3LeJZSO3Ir70uqinzlodZHuAeAFxBbXDo6jDGJsT9vKMSO9d6+xbqB6y
	 s79vQO09OAhdF12koCIcJDcHqA23RYKkFYEvNsmLYHMT4hRxaZW5Z/1ggBDAbVaM+M
	 7Fu02xA57cQJR9odROF5vSrVGF8mIcaK7pFdCX1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/369] kselftest/arm64: Fix check for setting new VLs in sve-ptrace
Date: Tue, 12 Aug 2025 19:26:27 +0200
Message-ID: <20250812173018.162098996@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 867446f090589626497638f70b10be5e61a0b925 ]

The check that the new vector length we set was the expected one was typoed
to an assignment statement which for some reason the compilers didn't spot,
most likely due to the macros involved.

Fixes: a1d7111257cd ("selftests: arm64: More comprehensively test the SVE ptrace interface")
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250609-kselftest-arm64-ssve-fixups-v2-1-998fcfa6f240@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/sve-ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index 6d61992fe8a0..c6228176dd1a 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -251,7 +251,7 @@ static void ptrace_set_get_vl(pid_t child, const struct vec_type *type,
 		return;
 	}
 
-	ksft_test_result(new_sve->vl = prctl_vl, "Set %s VL %u\n",
+	ksft_test_result(new_sve->vl == prctl_vl, "Set %s VL %u\n",
 			 type->name, vl);
 
 	free(new_sve);
-- 
2.39.5



