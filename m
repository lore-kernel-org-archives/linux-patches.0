Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F3214A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNisWxmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13774C433C7;
	Mon, 23 Oct 2023 11:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059639;
	bh=gh7Rq6RrNcFf3WKffDDEf2yRKSBmXoUaGkP/W6ed088=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNisWxmv8iE25sx5xRYdNos6yW4S+NM57JejSx5+fULAiX/s+NAgKJFvOwgrAzyKm
	 q69LjpRpVbvXPcghlZ5oHujjiAJ29LYtiNtvOTtLMK0M+TaPb9LDrz3S/LEY/4njt5
	 2M5PKNRLpxwvbzfPTIhD5PCFl+nnutynfNprS0XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.5 237/241] docs: rust: update Rust docs output path
Date: Mon, 23 Oct 2023 12:57:03 +0200
Message-ID: <20231023104839.651450780@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit bd9e54a42ce26026d67963c21b3fdfe8c7e68430 upstream.

The Rust code documentation output path moved from `rust/doc` to
`Documentation/output/rust/rustdoc`, thus update the old reference.

Fixes: 48fadf440075 ("docs: Move rustdoc output, cross-reference it")
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Link: https://lore.kernel.org/r/20231018160145.1017340-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/rust/general-information.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/rust/general-information.rst
+++ b/Documentation/rust/general-information.rst
@@ -29,7 +29,7 @@ target with the same invocation used for
 
 To read the docs locally in your web browser, run e.g.::
 
-	xdg-open rust/doc/kernel/index.html
+	xdg-open Documentation/output/rust/rustdoc/kernel/index.html
 
 To learn about how to write the documentation, please see coding-guidelines.rst.
 


