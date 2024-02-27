Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792F113A26F;
	Tue, 27 Feb 2024 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042831; cv=none; b=TgBgAqvbcxxzYqwe+NlLfEfzkGPN+HtcJPEc2WMuXciWPycBJfFelM8hjPV4KQH+qOFJ4YV7PaiEckfwlMehHEHuwd+pxpTkjtX8VxHciP8HF3x+yplNX+Qy6XdmKo0VIgN9GT+XWq1P2ajLzSE/GxzMhs9DeBlOLDj0ZpDxugg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042831; c=relaxed/simple;
	bh=QjHpztoayL6ivD+mdvnVbI/UVlJIRNZIBMSFxM/xpXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm0z1DDFyNbgSKoHHp4c6fvk1GWTK/ExB+nQ9RQ1oW6gV3FkoJ3WugKK3ERUISTiAnQxi7MmTion36jhq6dmAXI67eSLyMgajA29rgojz1fzNdjgHYYhjg2xTeWVm3sJIGSu3DIQfcBeJv3VgfnzFeL1Ysw/C5flfu/hzWK1RkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH8I2ztC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH8I2ztC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1915C433F1;
	Tue, 27 Feb 2024 14:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042831;
	bh=QjHpztoayL6ivD+mdvnVbI/UVlJIRNZIBMSFxM/xpXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH8I2ztC8KJZdnHd7rQiQaeeLDQXjlFnM3kSjxQ82fQ8JPEbbjT/rtUUo+cPkEx5r
	 nUpl5ysWUyC3Z0CHu6hdwt3zYE203fMEO8OLj1FDZGxR85LCXfnAOYUF6ns2aPU51S
	 rYsduOzC/QzVCUZdanaUOfEUJ511Hw7TYif9SpgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Huckleberry <nhuck@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/245] tools headers UAPI: Sync linux/fscrypt.h with the kernel sources
Date: Tue, 27 Feb 2024 14:25:25 +0100
Message-ID: <20240227131619.665539473@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit fabe0c61d842637b722344bcd49bfb1b76e2cc68 ]

To pick the changes from:

  6b2a51ff03bf0c54 ("fscrypt: Add HCTR2 support for filename encryption")

That don't result in any changes in tooling, just causes this to be
rebuilt:

  CC      /tmp/build/perf-urgent/trace/beauty/sync_file_range.o
  LD      /tmp/build/perf-urgent/trace/beauty/perf-in.o

addressing this perf build warning:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/fscrypt.h' differs from latest version at 'include/uapi/linux/fscrypt.h'
  diff -u tools/include/uapi/linux/fscrypt.h include/uapi/linux/fscrypt.h

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Huckleberry <nhuck@google.com>
Link: https://lore.kernel.org/lkml/Yvzl8C7O1b+hf9GS@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/uapi/linux/fscrypt.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
index 9f4428be3e362..a756b29afcc23 100644
--- a/tools/include/uapi/linux/fscrypt.h
+++ b/tools/include/uapi/linux/fscrypt.h
@@ -27,7 +27,8 @@
 #define FSCRYPT_MODE_AES_128_CBC		5
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_ADIANTUM			9
-/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
+#define FSCRYPT_MODE_AES_256_HCTR2		10
+/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
-- 
2.43.0



