Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015645;
	b=FuUORqiHll2L1PBdjjoYdNGKVwpOGibQWwjStCN49/Kr7urs7G04a+1qU3x9zaf915LR
	 /szeZJtcGNu1fOzE6eD5xP3ICHc4mV7Aiy2DRfZjPTXgSZliMK5cp8uxg9yuzQ0Hc/Ov9
	 NUNbxnHIj/qEFo+ltJIHrHo4QjsfP6Kr1gBLbJPK0s8lUv34Aal0TtzjPUYT09MWwVeWo
	 BpwCIlJd3G0GY5AlAPUPij54crHka7FjSI9mnq4NlFOzm8z+ePiChbLFB+jAoZ4NaRaT4
	 +wJrM8pvvkPl/M9qle44UHAclTAt4enaU8NO5mh7I86vAiUjZCYSKjkQQe0eOsv6BiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=77S3KfvKVmjxXQqHde0rbPe9JM1jUClwHUPVs4Mg5wA=;
	b=1BVFBK3rexHE/I03I266WSVbsZ7damgx1CzgLcl2k3EEUY1bA4EOC8aDAGQQUjAljNdD
	 8oIQvK3Op3o7pI1hJry/ze1uLcdxRo1HophIdM5IGjIpDl3JSKvNSIpQS2xNInncn4GM3
	 gS1MK5yflSuH4u/txyRIdZkqj8XSiNTtY6tOurAAPyZ37Z4S3HWb/ZA1uDaUSY0Axe+7d
	 jZoAN2X1UQe2QBDN4xSLNsqg+X4bwyhjmEETf3GocCUy67tu1KhvfmBs3VzqqWivpYh9Q
	 gX+rXxhCb0PYn2lXtTti4RHiAbgli0sot8N29pLJ5QkAzWb4Gpkmof06TTlYclCbVnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEdUMQD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56835606A32C;
	Wed, 18 Nov 2026 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEdUMQD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF501F000C8;
	Wed, 18 Nov 2026 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015645;
	bh=77S3KfvKVmjxXQqHde0rbPe9JM1jUClwHUPVs4Mg5wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEdUMQD+Rb+9U7WGhBueJjpYKGBz4/d2cUZSq2/WIPdDfQbXwVZ3c15n2sIq8Wx88
	 Wi9mAS7iA3P84mpOnzfWZFMqsvzRlGg3kBx5potWjhJJ8dmbcN4Yuwy3rB37+Tt0k0
	 26jURmU/vN/J222VLWLDS2ZQSJDXlTjuPiyqvSEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0245/2651] perf trace: Fix error checking in btf_struct_scnprintf()
Date: Wed, 18 Nov 2026 15:24:45 +0100
Message-ID: <20261118150256.675009619@linuxfoundation.org>
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

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit 02241f791aa28802cc05223a740e163e14cd5ea2 ]

btf_dump__dump_type_data() returns the positive number of bytes dumped on
success, or a negative error code (e.g., -EINVAL) on failure.

Currently, btf_struct_scnprintf() checks if btf_dump__dump_type_data()
returns 0. When a negative error code is returned on failure, this check
evaluates to false, causing the function to proceed down the success path
and advance arg->augmented.args past the unprinted struct data before
returning 0.

Consequently, when syscall__scnprintf_args() falls back to the default
argument beautifier upon receiving 0 from trace__btf_scnprintf(), the
fallback beautifier or subsequent arguments read from an erroneously
advanced augmented arguments buffer.

Fix this by checking for '<= 0' ensuring that on any failure or 0-byte
dump, 0 is returned without modifying the augmented arguments pointer.

Fixes: cb32035214b9a09d ("perf trace: Pretty print struct data")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
[ Restored that call to be a single line ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c3c7f1f85c530..4c8f91f0f854b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1066,7 +1066,7 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 		return 0;
 
 	/* pretty print the struct data here */
-	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) == 0)
+	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) <= 0)
 		return 0;
 
 	consumed = sizeof(*augmented_arg) + augmented_arg->size;
-- 
2.53.0



