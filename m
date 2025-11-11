Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF344C97;
	Tue, 11 Nov 2025 00:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822592; cv=none; b=dFOCjlkhnzNUK9COfmNZ/qY2OzwoibBtAtAM+IFIDfgyBUHtY623Z8KsZql/gOaZO/LhKhpbc/j1mMvU0E40t5OUxUIbRnhQlpY4sY4ONTAquj/E3AbVuWV6U8RUJw3XZAXgXKDUURcQc/brh7AxKYUHcvTwHIuHYg4QJc6F5Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822592; c=relaxed/simple;
	bh=P4La11gWHwUZ9Q1P5MliVuAq9AnZ2wdYlsi7DiHgUwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IHkqjp25ejafFVHre2kWXt802lTHFUe6W6FwZ9ETIGthsMj1444uGKA5pVsWqnF1YEywFqShGEQr4HdQkf6yx/nB92UTYkavhy3YKdjqlEmGFzKl4Ow9gx40Y1c0QFwT9fLwQAKNKpCEqOilNmgzPDE5rBq1RN8U1LH2KXPmOhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njF33hPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njF33hPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E952C16AAE;
	Tue, 11 Nov 2025 00:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822592;
	bh=P4La11gWHwUZ9Q1P5MliVuAq9AnZ2wdYlsi7DiHgUwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njF33hPEn372dmF2dMLOYKBhOPrRYrxWeebxFkKggwlqdaD5GnJrBGOH1XfkGzCbl
	 0iDiCWZR7+E5xbrtA4Vo59V7we22RY3e6BsCGACKhLzlYDvs+NHqw+7fKaaqNWl4DI
	 AnmqxjZmR0Ex77iO+s7hkawNN5YAaT7j7XLh1D9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 143/849] kselftest/arm64: tpidr2: Switch to waitpid() over wait4()
Date: Tue, 11 Nov 2025 09:35:13 +0900
Message-ID: <20251111004539.857559880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 61a3cf7934b6da3c926cd9961860dd94eb7192ba ]

wait4() is deprecated, non-standard and about to be removed from nolibc.

Switch to the equivalent waitpid() call.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20250821-nolibc-enosys-v1-6-4b63f2caaa89@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/abi/tpidr2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/tpidr2.c b/tools/testing/selftests/arm64/abi/tpidr2.c
index 4c89ab0f10101..1703543fb7c76 100644
--- a/tools/testing/selftests/arm64/abi/tpidr2.c
+++ b/tools/testing/selftests/arm64/abi/tpidr2.c
@@ -182,16 +182,16 @@ static int write_clone_read(void)
 	}
 
 	for (;;) {
-		waiting = wait4(ret, &status, __WCLONE, NULL);
+		waiting = waitpid(ret, &status, __WCLONE);
 
 		if (waiting < 0) {
 			if (errno == EINTR)
 				continue;
-			ksft_print_msg("wait4() failed: %d\n", errno);
+			ksft_print_msg("waitpid() failed: %d\n", errno);
 			return 0;
 		}
 		if (waiting != ret) {
-			ksft_print_msg("wait4() returned wrong PID %d\n",
+			ksft_print_msg("waitpid() returned wrong PID %d\n",
 				       waiting);
 			return 0;
 		}
-- 
2.51.0



