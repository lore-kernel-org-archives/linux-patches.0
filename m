Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE3F1BD014;
	Sun, 12 Jan 2025 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736695813; cv=none; b=pUSnQdj68WmaTm3HcBos2ATH9B/6NrRVU/fNVTJtw8k2ywHILdSOspqjK8OmriXzAlKCsSF98R/ykFB/Vf4HGz3hTp8uJYIwDejIIFoX5/e/tyCMq4SDNib+KIV6FM1v0vJqnqapVqkTKs3BmricLNaCVg5l/i/fz0fq0s4TYgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736695813; c=relaxed/simple;
	bh=PHarlXBnua/WIG5kYo+4gQaUrOC0x2ILafN5Fj0Q8Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+MiCuVeY/V3b6SqAWR4MibRTvKbCkqnx675cHQCvPESvcgh1e45pI9J64lXsHhCiL+gU3lYXcRWtZqJA1b/vlqyI7Vx3eUDpTWVCjEOrxD12A53HszibdV92Zee5UQhJEa3X7BpRsE7E4Q11NstKlmiaC7sNkiBMVKUtoZbqfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uiKoBKTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uiKoBKTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611E7C4CEDF;
	Sun, 12 Jan 2025 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736695813;
	bh=PHarlXBnua/WIG5kYo+4gQaUrOC0x2ILafN5Fj0Q8Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiKoBKTX/7w1mK6luP/yq874SzeFUSY4Fn3moqiwuYPY04mv1F1fb+puj9UKqtJz/
	 IAWx3YpwqbtyxT27AQLxupO6iRfPI4R3sXln9Xv/zrQcuBR4aOLmmsbC6HeZJuhPq6
	 JP03AwlwimBvftkfgVjw1oSJMOqHVxrs2WVOgZsmT7cGn1qi8tLx73mmpDOm0zVpCG
	 oVnV4dBjh4PRMxdFAe8HqFDTQYOFDnlWw9cgl51HJjj4q2MPodxBj6M2QrDkP73YMs
	 nX2uRezYPHKw4yPmn9cC2lGfTxVZ+uAnN9FHIdSBL2DdzyRYXXJQHjgtVkwOq0iOEw
	 Bj8FdORia0CFg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	tech-board@groups.linuxfoundation.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 3/3] docs: submitting-patches: clarify that signers may use their discretion on tags
Date: Sun, 12 Jan 2025 16:29:46 +0100
Message-ID: <20250112152946.761150-4-ojeda@kernel.org>
In-Reply-To: <20250112152946.761150-1-ojeda@kernel.org>
References: <20250112152946.761150-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tags are really appreciated by maintainers in general, since it means
someone is willing to put their name on a commit, be it as a reviewer,
tester, etc.

However, signers (i.e. submitters carrying tags from previous versions
and maintainers applying patches) may need to take or drop tags, on a
case-by-case basis, for different reasons.

Yet this is not explicitly spelled out in the documentation, thus there
may be instances [1] where contributors may feel unwelcome.

Thus, to clarify, state this clearly.

Link: https://lore.kernel.org/rust-for-linux/CAEg-Je-h4NitWb2ErFGCOqt0KQfXuyKWLhpnNHCdRzZdxi018Q@mail.gmail.com/ [1]
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/process/submitting-patches.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
index 7b0ac7370cb1..6754bc15f989 100644
--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -614,6 +614,10 @@ process nor the requirement to Cc: stable@vger.kernel.org on all stable
 patch candidates. For more information, please read
 Documentation/process/stable-kernel-rules.rst.
 
+Finally, while providing tags is welcome and typically very appreciated, please
+note that signers (i.e. submitters and maintainers) may use their discretion in
+applying offered tags.
+
 .. _the_canonical_patch_format:
 
 The canonical patch format
-- 
2.48.0

