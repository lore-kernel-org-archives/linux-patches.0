Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2253214;
	Thu, 15 Aug 2024 14:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731825; cv=none; b=Z4+AQUDvybNK6jM/4wQRqAckjYCWSL9kXBBjjkhVr/CZ95YlEm8WtmFcxBcPt/+94kLlRJ1OSdsicjHzHNwZhO+1gdyymhyCve3j57So6t2Mfj9lETJdO+/Y/NlChYsOMnVow4UqXqvqW9jKTEklQhVPmcjKkuGhYddMjC0Tp/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731825; c=relaxed/simple;
	bh=CrQtqt2yNRaIPypeVAacLqJuz0PSC1+TjCyINnt6E9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6XLJ7d58wJrkayha4yE+JeKvKLxE1oov1D/Vd7qUA9Q3Ei85KQDValuuMUwRh0mMGj3C7VF2npSmWvi5ONCHkpzt2VOMBSCQbLuV09zsVQ/yvFRQl7GXttUiFCz0YTuoS+rFZ7rtJsVk/O1u9waeBXb8dxYjLR7sle3/mUrtLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0q4Jf/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0q4Jf/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB35C4AF10;
	Thu, 15 Aug 2024 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731825;
	bh=CrQtqt2yNRaIPypeVAacLqJuz0PSC1+TjCyINnt6E9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0q4Jf/1MOhs8FWpe5FiY/d9TJrkNJH+48/j018sLuV7DUTrWaB7KIfJ7Z4mD27OR
	 Vtq086fw3seCWpMVtt2cjy33mOSkFmTMG8aMJYqWrePj6rSHxmKmwzXPBpyQlLR9/u
	 ee+VL2Zxd6tEVxs7eG3h24qTgfTd72is0vGmndDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jari Ruusu <jariruusu@protonmail.com>
Subject: [PATCH 5.4 249/259] Fix gcc 4.9 build issue in 5.4.y
Date: Thu, 15 Aug 2024 15:26:22 +0200
Message-ID: <20240815131912.386533839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jari Ruusu <jariruusu@protonmail.com>

Some older systems still compile kernels with old gcc version.
These warnings and errors show up when compiling with gcc 4.9.2

 error: "__GCC4_has_attribute___uninitialized__" is not defined [-Werror=undef]

Upstream won't need this because newer kernels are not compilable with gcc 4.9.

Subject: [PATCH 5.4 249/259] gcc-4.9 warning/error fix for 5.10.223-rc1
Fixes: fd7eea27a3ae ("Compiler Attributes: Add __uninitialized macro")
Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler_attributes.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -40,6 +40,7 @@
 # define __GCC4_has_attribute___noclone__             1
 # define __GCC4_has_attribute___nonstring__           0
 # define __GCC4_has_attribute___no_sanitize_address__ (__GNUC_MINOR__ >= 8)
+# define __GCC4_has_attribute___uninitialized__       0
 # define __GCC4_has_attribute___fallthrough__         0
 #endif
 


