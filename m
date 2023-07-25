Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796EF1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC89C433C7;
	Tue, 25 Jul 2023 11:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283183;
	bh=gAI8hI2wC0NJRAjT5qWBDsYQEBGkDtR5xZ4D0Mj64D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKE+EHDtLAIDu1zxAvwMkjFemDGxTN7TRzmpOCjlMRiqpmYft2hSGP1T6KBNj8hLW
	 MYKOQqYxSSXoY52QYp1MPlADooCa1v7S9hPJeRGNixJ0WVE/iXluuQsIC5Pi9OO9N8
	 fZAN+Xh62CrgGFjRSnTCyAKuArKWBLx0RWKjmkmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuma Ueda <cyan@0x00a1e9.dev>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 169/183] scripts/kallsyms.c Make the comment up-to-date with current implementation
Date: Tue, 25 Jul 2023 12:46:37 +0200
Message-ID: <20230725104513.851301667@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuma Ueda <cyan@0x00a1e9.dev>

commit adc40221bf676f3e722d135889a7b913b4162dc2 upstream.

The comment in scripts/kallsyms.c describing the usage of
scripts/kallsyms does not reflect the latest implementation.
Fix the comment to be equivalent to what the usage() function prints.

Signed-off-by: Yuma Ueda <cyan@0x00a1e9.dev>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://lore.kernel.org/r/20221118133631.4554-1-cyan@0x00a1e9.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kallsyms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -5,7 +5,8 @@
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  *
- * Usage: nm -n vmlinux | scripts/kallsyms [--all-symbols] > symbols.S
+ * Usage: kallsyms [--all-symbols] [--absolute-percpu]
+ *                         [--base-relative] in.map > out.S
  *
  *      Table compression uses all the unused char codes on the symbols and
  *  maps these to the most used substrings (tokens). For instance, it might


