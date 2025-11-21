Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E003126CE33;
	Fri, 21 Nov 2025 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731419; cv=none; b=g3NyjwLy/iziZ4Mb6g8vGprgppdST4fkZthOqDC/n/QwyLwdS2uMHyBO4myJzoM5cWEr5J+3gXT07Bg+xRvUOkFseCJgsiukovEGxBEhSFgNnHcfh9AjVqzy56lfXLiq8hBAuF6zT8CSPZPNIayH0Z3zPrRtyzHGPyPMkrih9AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731419; c=relaxed/simple;
	bh=5pOMt5LvJ+oKpPlMzcwq7Gy8eymdZunj0o9Cv/EBY98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+riDNdbSwAOkXnVYVFuHnEiGHqW0nsGccLW10YnmYhZlo9E03M8kYh8rnvr0v6iKR5MnHRJ9hufNAU7oj2725DEyvrw9BJvFTQ0+RzUeYkCJtoyip7Itydn5XEraRLCFZsTt2GXZCl4v6HUq0lvPhIPzozbis0yw4wUX3+YBEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdYPiRtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdYPiRtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F910C4CEF1;
	Fri, 21 Nov 2025 13:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731418;
	bh=5pOMt5LvJ+oKpPlMzcwq7Gy8eymdZunj0o9Cv/EBY98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdYPiRtjFki1nUWJjMRGTIkvSJlEwATozJZOg4xhgqmG5qNosltqPkGElssRjdNru
	 dHlpnecwPSluilAxgNBmhQVhDZmTeb5l7+Q7zH4Zl7h94ejwBN9q645y2Y/m8QIENl
	 QkpB5hEIolUj/+xonNVKPT37lwQdxBxLKLU4H5aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.17 202/247] x86/microcode/AMD: Add Zen5 model 0x44, stepping 0x1 minrev
Date: Fri, 21 Nov 2025 14:12:29 +0100
Message-ID: <20251121130201.974540567@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit dd14022a7ce96963aa923e35cf4bcc8c32f95840 upstream.

Add the minimum Entrysign revision for that model+stepping to the list
of minimum revisions.

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/e94dd76b-4911-482f-8500-5c848a3df026@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -224,6 +224,7 @@ static bool need_sha_check(u32 cur_rev)
 	case 0xb1010: return cur_rev <= 0xb101046; break;
 	case 0xb2040: return cur_rev <= 0xb204031; break;
 	case 0xb4040: return cur_rev <= 0xb404031; break;
+	case 0xb4041: return cur_rev <= 0xb404101; break;
 	case 0xb6000: return cur_rev <= 0xb600031; break;
 	case 0xb6080: return cur_rev <= 0xb608031; break;
 	case 0xb7000: return cur_rev <= 0xb700031; break;


