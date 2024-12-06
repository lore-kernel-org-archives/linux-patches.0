Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEFF1514F6;
	Fri,  6 Dec 2024 14:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496306; cv=none; b=fjTIJ28tqLcIfcIGf88loMt7ijtWy+r55x9OWGzYYIPJUntsNJNkDgXjPq6nDCoNbuTSYw7ziMFrIXi2653vSmSKSEmWhRxR9jEYodfe5kU7g5g1K2H2YvqQO6s2Ko2C5X3k3coBdBuUyCrvNNOJiyVpGwGaPLn94s7jIG4ucaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496306; c=relaxed/simple;
	bh=p6B40sn17f/k1sg0rVG9kRmsTqsWJxa4x+FPwo0+Ilk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y74Qc4nkb/6D/6uZBQNtUWFxaXgVeSmmQaEhXn1rRz+OB18o7m+kxsFxu81EqrwGc7UrNAOLuQdEGTJZm/NyPk+3FY37wJvtrltZy0URr3QqWjkr9KsMKYd/hnoRjWI9sS1ksTJzAcZlFM8NiNGTu0LDFoHP7yoiPwQcHTax9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoHA1FVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoHA1FVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFC3C4CEDE;
	Fri,  6 Dec 2024 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496305;
	bh=p6B40sn17f/k1sg0rVG9kRmsTqsWJxa4x+FPwo0+Ilk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoHA1FVE+Yp9mb7w3FEb25ckISAKjNnkAGEL/+urKNlF17Jptt2cB7Gtvxhdo+4bZ
	 0trYzdvj2MX/6FZVZKqJppXDJposyU7GMmV/WITaiSkvo4MTccTeaRK3noPk6QslNv
	 Posetkgt3qYJ37U/K3O0QJKrsdEM2U+tu6AglSpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 6.12 112/146] binder: fix BINDER_WORK_CLEAR_FREEZE_NOTIFICATION debug logs
Date: Fri,  6 Dec 2024 15:37:23 +0100
Message-ID: <20241206143531.967634419@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 595ea72efff9fa65bc52b6406e0822f90841f266 upstream.

proc 699
context binder-test
  thread 699: l 00 need_return 0 tr 0
  ref 25: desc 1 node 20 s 1 w 0 d 00000000c03e09a3
  unknown work: type 11

proc 640
context binder-test
  thread 640: l 00 need_return 0 tr 0
  ref 8: desc 1 node 3 s 1 w 0 d 000000002bb493e1
  has cleared freeze notification

Fixes: d579b04a52a1 ("binder: frozen notification")
Cc: stable@vger.kernel.org
Suggested-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20240926233632.821189-6-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 2be9f3559ed7..73dc6cbc1681 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6411,6 +6411,9 @@ static void print_binder_work_ilocked(struct seq_file *m,
 	case BINDER_WORK_FROZEN_BINDER:
 		seq_printf(m, "%shas frozen binder\n", prefix);
 		break;
+	case BINDER_WORK_CLEAR_FREEZE_NOTIFICATION:
+		seq_printf(m, "%shas cleared freeze notification\n", prefix);
+		break;
 	default:
 		seq_printf(m, "%sunknown work: type %d\n", prefix, w->type);
 		break;
-- 
2.47.1



