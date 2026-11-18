Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015190;
	b=ddr5ArmTMnIBnx6i5sYwzMl0ZujakHu8VGC7DCanM9fHZxyT6kyAQ0tvdvkhifIY2TXo
	 Bqon+CU9S1MF8XLxoXe2djQNXVi+yM7B5euv2d7zuyHztY6QjUv9zADPxBto6gvddmOtI
	 RV9mmkCKf9Q5j/ZDeUk+RZJNS6GS7J8nO0OUA758e4e3/A3zrah5xybsMyxatyxeWWtXb
	 ASQ+S2vHKCtJFOTNkaQxFVtY56qL8sQVlxv5cdFxv/h6evMZVF6hD5GxCfxileC/YFEqY
	 +4LKMX01lHrf9BIvwYq5KVr8jMHpDMjtdLzKB4GPNwm5rUWMW/GlpkNPl5mq1r+i76Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fuPXJdhwTKSom+9VjUg1oNzqfinhKFp0bZUUs3pKICI=;
	b=Su28UXwJT+W1HLtIarxwK+W8QduTKsIfvM5FbfRqiu9wdsujLCRrf08UVlbu6wVn6hLh
	 sZW1zzqIad8kwzdDYEGXBcz/3ROFeQWgck0yrYPahjSNit+BVpDAKYB1so7i+F7q+EyuY
	 WXbmh+wGzLSUsY4NUhL8L6TowNEdoY+BLHhggnznpQvZaxW3XyEsdRnhRPBYPrJ3yCf5N
	 7za3BBO/hUtD0kEcCow1Xo4M39VuAneenxjfGOADoxFduuhKkB8vzk2IJC7L8mlkyHxRl
	 btQgJ4z6yUM5BqX8ftVw0jhptpPCMiMVAwwbIsrTTmbhHwzp7DHZ412N9dnBGG0gVXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oeS9KEyT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2160A3809;
	Wed, 18 Nov 2026 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oeS9KEyT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A151F000CA;
	Wed, 18 Nov 2026 15:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015190;
	bh=fuPXJdhwTKSom+9VjUg1oNzqfinhKFp0bZUUs3pKICI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeS9KEyTtwMXYxGFugCytrkAhIPfOjdHw29fkWjSeS5ICHo+d5sVL0arF0gBMA8gD
	 u61J16eZ89/ys/qG0gp3koiBOdZo8Eg2SrcarSaCgsTjo0L29ipnTqZTHzr4xBTlI1
	 lAN2yW4v5GtEu0sAw9QMj/B++0bIS0E7+5Xf115A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0086/2651] selftests/bpf: NUL-terminate bpftool command output
Date: Wed, 18 Nov 2026 15:22:06 +0100
Message-ID: <20261118150251.008690716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit 4f8a4c76f6704667111d76404bdea4fef0373358 ]

run_command() writes a bpftool command's output into a caller-supplied
buffer, and every caller treats that buffer as a C string.

However fread() reports a byte count and doesn't terminate the
string. The helper does not terminate either, so callers have to zero
the buffer first. prog_tests/bpftool_metadata.c does not, for example.

Read one byte less and terminate in the helper.

Fixes: f21fae577446 ("selftests/bpf: Add a few helpers for bpftool testing")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260828215207.3105313-5-ihor.solodrai@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bpftool_helpers.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpftool_helpers.c b/tools/testing/selftests/bpf/bpftool_helpers.c
index 0a2a4f0a2794b..c49fdd90eb033 100644
--- a/tools/testing/selftests/bpf/bpftool_helpers.c
+++ b/tools/testing/selftests/bpf/bpftool_helpers.c
@@ -53,6 +53,7 @@ static int run_command(char *args, char *output_buf, size_t output_max_len)
 	static char bpftool_path[PATH_MAX] = {};
 	bool suppress_output = !(output_buf && output_max_len);
 	char command[BPFTOOL_FULL_CMD_MAX_LEN];
+	size_t n;
 	FILE *f;
 	int ret;
 
@@ -68,8 +69,10 @@ static int run_command(char *args, char *output_buf, size_t output_max_len)
 	if (!f)
 		return 1;
 
-	if (!suppress_output)
-		fread(output_buf, 1, output_max_len, f);
+	if (!suppress_output) {
+		n = fread(output_buf, 1, output_max_len - 1, f);
+		output_buf[n] = '\0';
+	}
 	ret = pclose(f);
 
 	return ret;
-- 
2.53.0



