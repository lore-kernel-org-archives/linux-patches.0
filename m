Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EE63C2F;
	Wed, 21 Feb 2024 13:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523255; cv=none; b=CtTFQC/vopldq1c805ItagZQusvn1Y6buDad3MFYY2XztisenunSepQDokwOLdU1PSuaeizBoLGuotij5Sv0eEvhJqJPBZzQG2EZb8bNKEcmhr/XqgB72rjnZVT914fYGqEHEP2y7YfQXA0B9+a35dE0YKevxB5sHm5ziyEnpZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523255; c=relaxed/simple;
	bh=3pATa4OXR6fOzB0XU85Ijc/nBFJIBV1MI7kAeYaLasU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mjrz/urA4F/zyS/x4ExhEFeENQFulLnxr4GCjcqf44CKQla8lITlMAK/HFs1PsiJZ1fCm2rtJkd5WsTODq2lt26PC15Dq1DlC/tb4bzkJ58PQ5hJSn17eEQiyXllQmBXLcQfcvGV91uY/QSUe2si31P7TgeBGJBh9gLiPNOMwf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czBxnmfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czBxnmfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77C4C433F1;
	Wed, 21 Feb 2024 13:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523255;
	bh=3pATa4OXR6fOzB0XU85Ijc/nBFJIBV1MI7kAeYaLasU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czBxnmfOebXZFVKRVX1Oh6E5lnNsPysjW3uY/mc2lzTvkxZS8zCMey2pr/UWIr8SB
	 XajWW8p9Y1UKCsYAU9nWjs9KVAcOv54NxGa5eJ3XPdxVUFPMnLk5M2VfqgrL5oeaxn
	 dQBEEkHEdm5YkOqG9FvU7ZXvQilPDqKXvt604lTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 5.15 379/476] firewire: core: correct documentation of fw_csr_string() kernel API
Date: Wed, 21 Feb 2024 14:07:10 +0100
Message-ID: <20240221130022.065931063@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 5f9ab17394f831cb7986ec50900fa37507a127f1 upstream.

Against its current description, the kernel API can accepts all types of
directory entries.

This commit corrects the documentation.

Cc: stable@vger.kernel.org
Fixes: 3c2c58cb33b3 ("firewire: core: fw_csr_string addendum")
Link: https://lore.kernel.org/r/20240130100409.30128-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/core-device.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -100,10 +100,9 @@ static int textual_leaf_to_string(const
  * @buf:	where to put the string
  * @size:	size of @buf, in bytes
  *
- * The string is taken from a minimal ASCII text descriptor leaf after
- * the immediate entry with @key.  The string is zero-terminated.
- * An overlong string is silently truncated such that it and the
- * zero byte fit into @size.
+ * The string is taken from a minimal ASCII text descriptor leaf just after the entry with the
+ * @key. The string is zero-terminated. An overlong string is silently truncated such that it
+ * and the zero byte fit into @size.
  *
  * Returns strlen(buf) or a negative error code.
  */


