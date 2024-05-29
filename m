Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6367CD27E;
	Wed, 29 May 2024 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717018967; cv=none; b=BlROPyRTZgalhaRPG4jxjNYJM5YQUuuqEYxHRAoX8XytCsf6tBgZtw8UasWxen4j56Vf9c1VApRRUwhH8YCamVTFMPNwcbm34x5iP5gyGoWPi3y2Tw6Y2RY0eoUMCxH223rSHqaozHfRwMM3t8CNWH45ls6ksq+PdjryiQA6Frs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717018967; c=relaxed/simple;
	bh=PrJQxMmS5LHKVU/EWMJ417PqE4hDeduiM64YoyvEzYM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hT0dcOKi+0ibvxnock2mUnds90TjbKrYqvy1TmB3fnugutnb6yoGiv7lVw0q4H6lXA1bTIK1e+bqR6mcDra09yDsn2twDKL7iiVkLz/avGSkuDsRYYSpvpTSQGha+kT701csFgTVQJEEIRHDEaD1NnyYrz1G47KorD5EGl46F1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6I6i+uU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6I6i+uU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CFEC113CC;
	Wed, 29 May 2024 21:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717018966;
	bh=PrJQxMmS5LHKVU/EWMJ417PqE4hDeduiM64YoyvEzYM=;
	h=From:Date:Subject:To:Cc:From;
	b=G6I6i+uUfePjluSUN/8e6Tlzu/C0vl6O5qd6P1nt+HOjb8v6KRP7PurU55Bg2IUSY
	 gm+qeUTHt0YpsRQ/DTJ+fGjdurWISS5ENLQwvtGx7AqJNbUbfXl4ojg88AZA0ZulgQ
	 edW6/f2ZV+W14SixY1itbvPVNYyAxYs4M2iahlttRWpLpidOMqV5T5Mb2d4g0x2sJL
	 TdT0wtueFE1hCXZi0LvT/MUwupt0ridBSp1WHYVxGWsperil39z9bC733mKHjHg8R3
	 7sGAvmQmATGPGtEQHoKdkGrDNYp+vS1oLJfUoD23JT/r05vi0ibMuHMU7gvPPOxj47
	 DQJ4xwMikeQEw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 29 May 2024 14:42:40 -0700
Subject: [PATCH] nvmet-fc: Remove __counted_by from
 nvmet_fc_tgt_queue.fod[]
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-v1-1-286adbc25943@kernel.org>
X-B4-Tracking: v=1; b=H4sIAE+hV2YC/x3NTQrCMBRF4a2UN/ZCDFbUrYgDzbupGZjU/BSld
 O8Gh9/knFUKc2CRy7BK5hJKSLFjvxvEPe9xIoJ2izX2YEZ7huY0w6UWKxWPL3xSxOXFCu9Qp4p
 3YyNGQ1XrT3o0lB6bM334/EfX27b9AGh/2qh4AAAA
To: James Smart <james.smart@broadcom.com>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2507; i=nathan@kernel.org;
 h=from:subject:message-id; bh=PrJQxMmS5LHKVU/EWMJ417PqE4hDeduiM64YoyvEzYM=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnhC0OVDR7cThJnS5CUrK/pXtt6dLv0nTVXKn9wb9iv7
 M5SbP66o5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEwkVojhf0IKxxuTGVNu9DPP
 khHSMrnLl/Lg9nEt/VDrn13qARELXjIy/FOR5TwVfOa2oYkan+uOKWXLHsun7N512PVL/OR2yTd
 t3AA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Work for __counted_by on generic pointers in structures (not just
flexible array members) has started landing in Clang 19 (current tip of
tree). During the development of this feature, a restriction was added
to __counted_by to prevent the flexible array member's element type from
including a flexible array member itself such as:

  struct foo {
    int count;
    char buf[];
  };

  struct bar {
    int count;
    struct foo data[] __counted_by(count);
  };

because the size of data cannot be calculated with the standard array
size formula:

  sizeof(struct foo) * count

This restriction was downgraded to a warning but due to CONFIG_WERROR,
it can still break the build. The application of __counted_by on the fod
member of 'struct nvmet_fc_tgt_queue' triggers this restriction,
resulting in:

  drivers/nvme/target/fc.c:151:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct nvmet_fc_fcp_iod' is a struct type with a flexible array member. This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
    151 |         struct nvmet_fc_fcp_iod         fod[] __counted_by(sqsize);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Remove this use of __counted_by to fix the warning/error. However,
rather than remove it altogether, leave it commented, as it may be
possible to support this in future compiler releases.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2027
Fixes: ccd3129aca28 ("nvmet-fc: Annotate struct nvmet_fc_tgt_queue with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/nvme/target/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 337ee1cb09ae..381b4394731f 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -148,7 +148,7 @@ struct nvmet_fc_tgt_queue {
 	struct workqueue_struct		*work_q;
 	struct kref			ref;
 	/* array of fcp_iods */
-	struct nvmet_fc_fcp_iod		fod[] __counted_by(sqsize);
+	struct nvmet_fc_fcp_iod		fod[] /* __counted_by(sqsize) */;
 } __aligned(sizeof(unsigned long long));
 
 struct nvmet_fc_hostport {

---
base-commit: c758b77d4a0a0ed3a1292b3fd7a2aeccd1a169a4
change-id: 20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-50edd2f8d60e

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

