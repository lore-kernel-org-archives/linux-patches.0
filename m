Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309F1DF73C;
	Tue, 29 Apr 2025 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946598; cv=none; b=pFS2nQgXaOU9Uz3m6CtOBmVIcH5YWBvUvaYyOQZRNUcon2Wa8MwATnCt+uvhnn1fuJUwwDftOttOFnjXLmG3XQFldFHRNqFZ6TC2fUj3kwce9vK1un2mX5nZLCitj7wbSUjVNA3Y1Y6i8x/q6FlX4+mqops4xpnEDVAX6YsAWSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946598; c=relaxed/simple;
	bh=W6RifY58B+wmJYEtSbwikmB+Ad2MlKkBYXcz4AzLzf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unZ4Jnku8k7p6qR0i7MHfDaKH/0E7l7SARgZWe4KW6djryIrgXtyITJQ32INdvXk6wBuBaknAaMLqkUZbk0AiZbYCuAW9H5EliVSAx6QTN0oIkoCCysp/DnGH95simouHzAh/scoivoMiGIMuy1UsgBInIFJ85r1+qaV0xYFXUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSPtjZ/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSPtjZ/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F27C4CEE3;
	Tue, 29 Apr 2025 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946597;
	bh=W6RifY58B+wmJYEtSbwikmB+Ad2MlKkBYXcz4AzLzf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSPtjZ/wzQSFk1ctpRD6aEEgjasi3RMoR/UCjVFZLSpztgSQ8ZFewNhagoA/xMYlU
	 5apXD6jg4ypqnWPfsjcePcliSNwGoxpW45eSthTbcCsimTMQLYvHJthWFpYbYBct54
	 f7TQ/uzo4iBVaQtkJJHVqsezrQGdNKIv98yhEZ0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.14 310/311] objtool: Silence more KCOV warnings, part 2
Date: Tue, 29 Apr 2025 18:42:27 +0200
Message-ID: <20250429161133.691573516@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 55c78035a1a8dfb05f1472018ce2a651701adb7d upstream.

Similar to GCOV, KCOV can leave behind dead code and undefined behavior.
Warnings related to those should be ignored.

The previous commit:

  6b023c784204 ("objtool: Silence more KCOV warnings")

... only did so for CONFIG_CGOV_KERNEL.  Also do it for CONFIG_KCOV, but
for real this time.

Fixes the following warning:

  vmlinux.o: warning: objtool: synaptics_report_mt_data: unexpected end of section .text.synaptics_report_mt_data

Fixes: 6b023c784204 ("objtool: Silence more KCOV warnings")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/a44ba16e194bcbc52c1cef3d3cd9051a62622723.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202503282236.UhfRsF3B-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.lib |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -275,7 +275,7 @@ objtool-args-$(CONFIG_MITIGATION_SLS)
 objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
 objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
 objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
-objtool-args-$(CONFIG_GCOV_KERNEL)			+= --no-unreachable
+objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
 objtool-args-$(CONFIG_PREFIX_SYMBOLS)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
 
 objtool-args = $(objtool-args-y)					\


