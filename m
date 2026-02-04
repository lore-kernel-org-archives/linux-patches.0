Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F0E27702D;
	Wed,  4 Feb 2026 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219114; cv=none; b=lT6QN4yDRwz221k7wVSprGsRAKibMmXLL8R1nrCniK0cTvn9nwG0MLIhZFVVZv1nzbwSqKAPQsSfgeQDKR60yWEZoQXmOaAqdOVFnB+Gqm8Jnas9RATbNaflMyRvtw58WL58t1FfmkCUPsJjqaVNweXoCMhEGnfl8O273zAY7gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219114; c=relaxed/simple;
	bh=mydqGhKO2PuVNFcuYkwX/F+my5aAvmWm5/O9yn8LdhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3NDrb3SlQzJU6zPZySnwPuT92urQCl1x5yzwq3z4mgPfVKLDilpCxWFSjx0WY20v6F4m7oIPOuIq2yupTDfMk5+xfSnLUJIMF/dH5Jj5ozgQWpthQowsyXYOLCExlh4VM6HaVJw7acA90XAZM7AJwAS6y3yGtjF0WLYO4BhCY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRECZ/mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRECZ/mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1CDC4CEF7;
	Wed,  4 Feb 2026 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219113;
	bh=mydqGhKO2PuVNFcuYkwX/F+my5aAvmWm5/O9yn8LdhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRECZ/mtapgx/8oviqQGRyCVvLMXbTyNuAXQF3+LQpVg/pwNoXXxULWfo1L924hF8
	 WkT7r4/7XZbrU0T/FNW/jvYOI49CEKdP7tUy6LtMEDiXbyXVlYzgGKzEkaiOzDOkf2
	 KPLGmSHbidXRPTQC1ai991pN+9EGvM4BkuaEeA68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Chen Miao <chenmiao@openatom.club>,
	Nicolas Schier <nsc@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 072/122] kbuild: rust: clean libpin_init_internal in mrproper
Date: Wed,  4 Feb 2026 15:40:54 +0100
Message-ID: <20260204143854.443243717@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Miao <chenmiao@openatom.club>

commit a44bfed9df8a514962e2cb076d9c0b594caeff36 upstream.

When I enabled Rust compilation, I wanted to clean up its output, so I
used make mrproper. However, I was still able to find that
libpin_init_internal.so in the rust directory was not deleted, while
all other corresponding outputs were cleared.

Thus add it to the `MRPROPER_FILES` list.

Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Chen Miao <chenmiao@openatom.club>
Fixes: d7659acca7a3 ("rust: add pin-init crate build infrastructure")
Cc: stable@vger.kernel.org
Acked-by: Nicolas Schier <nsc@kernel.org>
Acked-by: Benno Lossin <lossin@kernel.org>
Link: https://patch.msgid.link/71ff222b8731e63e06059c5d8566434e508baf2b.1761876365.git.chenmiao@openatom.club
[ Fixed tags and Git author as discussed. Reworded slightly. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1590,7 +1590,8 @@ MRPROPER_FILES += include/config include
 		  certs/x509.genkey \
 		  vmlinux-gdb.py \
 		  rpmbuild \
-		  rust/libmacros.so rust/libmacros.dylib
+		  rust/libmacros.so rust/libmacros.dylib \
+		  rust/libpin_init_internal.so rust/libpin_init_internal.dylib
 
 # clean - Delete most, but leave enough to build external modules
 #


