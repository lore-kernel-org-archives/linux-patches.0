Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3844847988D;
	Sat, 12 Sep 2026 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213488; cv=none; b=NknAS7aKbt4HeraAhqNCDXvpV7FGLbP1FLwkBXzYKNwiiScDi2Egv/4FbErgolv03kz5ttKqP3LMHjhQ91j4uBOXaWvJ8BG4csmoZlJIS5XdDjm+cNaTNgZP1nXyEeH7cLUH6jWrA8J0bx+q6eCKFMBLTUA5nhKnxOSZVJC3d3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213488; c=relaxed/simple;
	bh=IHSDelcGIFZc3ouvX/bwpyiXO/pn2/fqUIC+lZy3bZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku+EUP9OhG0kMJLITccGNzn860Y0PtU/BKVK3j9rLk3/0a6YH+aZFVFz3H9kP99M36CudOJ4gx3W3oITRGMNH9gT3VNys/+s4CFQLhB8iBQw3IT4ZpgBjhTDqhCSb81qnFAIb3OUF4szjgUBoulbSJU5OQzJQsHH19XYzOF8Zm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNdaULAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNdaULAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C0D1F000FF;
	Sat, 12 Sep 2026 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213484;
	bh=Nl39yuw5CeKQJzQWla+N9slARKckgyCKpYqzXLXJZlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNdaULAYCLRNgzqdrHZ7Q1avI/S2+ODJHnZnxfuItSVrOr5mzCNXmU8HmRR/pS23/
	 nXfe8oty4Z10N+jwvwFSDs6VBK41UYrxP9dsOP+1esGB11wFM6a+FRXMjpNiOSuKP/
	 n0ujSEopbRRL/BmfkmFtQX8N/jLlu37xSGkhIlto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0094/1376] parisc: Fix alignment of asm statements in head.S
Date: Sat, 12 Sep 2026 08:42:00 +0200
Message-ID: <20260912065609.657847883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 04cf68c9a76e3c6b67ad056a66a14923abf85925 upstream.

All assembler statements need to be 4-byte aligned. Prevent a possible
misalignment if someone changes the preceeding string and it's length is
then suddenly not a multiple of 4 any longer.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/head.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -105,6 +105,7 @@ $iodc_panic:
 	or		%r10,%r10,%r10	/* qemu idle sleep */
 msg1:	.ascii "Can't boot kernel which was built for PA8x00 CPUs on this machine.\r\n"
 msg1_end:
+	.align 4
 
 $cpu_ok:
 #endif


