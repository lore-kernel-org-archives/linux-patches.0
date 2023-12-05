Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2156AA0;
	Tue,  5 Dec 2023 03:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnjEzCUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AD0C433C7;
	Tue,  5 Dec 2023 03:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746538;
	bh=Tmj760NrMFVtoqCCAIRwDvkIeUwLUBWdadsZuhYu7+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnjEzCUucE7o5cCcXckXQujqTHIjiE34nfcIFl3ffMmUbLZFFn3pIxDzVlEkAhwMd
	 9fvyf0LKB9YQtmUdHvnkkMWhsiOuvByMCKRpmpu3EeDWkmuMVxqwoMLFfaDUFSGSBy
	 ukaYYvsuUWGzLLRvstIM/ZFkQNtNNysOcFN6fLJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 062/134] parisc: Ensure 32-bit alignment on parisc unwind section
Date: Tue,  5 Dec 2023 12:15:34 +0900
Message-ID: <20231205031539.468778002@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit c9fcb2b65c2849e8ff3be23fd8828312fb68dc19 upstream.

Make sure the .PARISC.unwind section will be 32-bit aligned.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -130,6 +130,7 @@ SECTIONS
 	RO_DATA(8)
 
 	/* unwind info */
+	. = ALIGN(4);
 	.PARISC.unwind : {
 		__start___unwind = .;
 		*(.PARISC.unwind)


