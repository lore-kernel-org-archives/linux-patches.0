Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029632;
	b=i5WcYQ0b5k+vOk52njaKKDqRijeeAWXjFVwzZDwy9YKrpd2k/wudFlYuuNzjr042Iq0t
	 1iA3+G8wHokdvk2kHdvL++lLrnBCVk9iOUw8s7KE/C/I3gyZc2iT7vXWM7usHQ6TufeN2
	 MNQrcoNiS/pxcE2BBiqc9oihS7jEeLOYxpBt6DkvWKWdLb1Kykbx2jZM3UC3ftyzqXYJW
	 9b9zMsQsJ3SL9+vaDFxD+N7+CPu/qlil2XdI5hw6A77Pw5yJDvwtfDlhYlwcwCVQjwRv5
	 jSuZNHeR5i37bsbPjyBPwpPIO0D0pljI+T8eZ9fU5FzAzoD8Nae/RHhJ873/rR5EilA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fxQf9PMCHxv1zzXDh2jotPrHTdWa7/oDw+ymWNxO4lo=;
	b=NKe5CgWCAfUIv+wvtgyCMSb9qOscMbBW8Ke4W5vXMM6ggjmEmry+ImXKtdEBWpFSGo0z
	 UwYzVuYMJcPnahazD9Ae0Vz2S6dmtWyzkDJOLETl0MtAYhIzjfbGQl1TJjCwdNAgrZif7
	 n53g0+jZ9fkdp5gASB4pM/sPNSNp2NMbp9KdGd7UyXZhyEGxGKYsLfRzisXE782+TH3GW
	 cE2JzoR3bDm/DCnMhl9ZMsNa+cBF0roG8HeLHq1HpzU724HisdjUrbM8ZW9Y8o/ID3L0/
	 N6PujCG4mywd57zHYLEPklZlkr3lksIvrekhTMIhTydU/aaKKtWz0teZ3xOpyNFut8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+yDKDSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9B5606A332;
	Wed, 18 Nov 2026 19:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+yDKDSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291671F000C7;
	Wed, 18 Nov 2026 19:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029632;
	bh=fxQf9PMCHxv1zzXDh2jotPrHTdWa7/oDw+ymWNxO4lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+yDKDSwzjFcI8++rEMkSeH8l936GOdSokWblDCbkx/+O2rxxp/IQcwsY5RMVjgkz
	 ZAbCsSBldw1GyAT7cfh96HdCHP9wEHZmx+C2qsbFy6qZV44yCqUfNqpCKn6OcGwrAg
	 jhCMUpxpLzfuZdtlyqvYLhgrq6r+mgVhRkKgUgwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0417/1756] loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation
Date: Wed, 18 Nov 2026 15:42:24 +0100
Message-ID: <20261118150025.322746115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit eb0b0d222a832b6ec851e56d4922a775ac762955 ]

Commit 99d5cadfde2b ("kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG
and KEXEC_SIG_FORCE") removed CONFIG_KEXEC_VERIFY_SIG but left the
LoadPin documentation pointing at it. Refer to CONFIG_KEXEC_SIG instead.

While at it, clean up the grammar of the sentence.

Fixes: 99d5cadfde2b ("kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260905013655.58665-1-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/LSM/LoadPin.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/LSM/LoadPin.rst b/Documentation/admin-guide/LSM/LoadPin.rst
index dd3ca68b5df18..a90fd9dac9606 100644
--- a/Documentation/admin-guide/LSM/LoadPin.rst
+++ b/Documentation/admin-guide/LSM/LoadPin.rst
@@ -23,9 +23,9 @@ sysctl allows for easy testing on systems with a mutable filesystem.)
 It's also possible to exclude specific file types from LoadPin using kernel
 command line option "``loadpin.exclude``". By default, all files are
 included, but they can be excluded using kernel command line option such
-as "``loadpin.exclude=kernel-module,kexec-image``". This allows to use
+as "``loadpin.exclude=kernel-module,kexec-image``". This allows using
 different mechanisms such as ``CONFIG_MODULE_SIG`` and
-``CONFIG_KEXEC_VERIFY_SIG`` to verify kernel module and kernel image while
-still use LoadPin to protect the integrity of other files kernel loads. The
-full list of valid file types can be found in ``kernel_read_file_str``
-defined in ``include/linux/kernel_read_file.h``.
+``CONFIG_KEXEC_SIG`` to verify kernel modules and kernel images while
+still using LoadPin to protect the integrity of other files the kernel
+loads. The full list of valid file types can be found in
+``kernel_read_file_str`` defined in ``include/linux/kernel_read_file.h``.
-- 
2.53.0



