Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524021DDCE;
	Tue, 16 Jul 2024 16:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145858; cv=none; b=G43r0aHUpLJLTTlbrk8ZAqfrrpaSiGzs+AlNTrMein8hdmfcBjA1oWMXBk0uvstHi8b18JZhcC2HKZ45XACvopF794I/xnel2knDLVrC9XKsiVUniIsW7huq+SIuJgoBPb/gfC1fo2uUB18IhjgMYzwAJMy4ncoNtqUqMPTELvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145858; c=relaxed/simple;
	bh=8+1HwU6TBHtGHtEZa67CP78u+hTUm4IyMwQiCspDj9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrIWjLygAeHylwaBvNOeWSK+A7LuFR8jvCnfzcXAqAMcbiqY4FDi7jglTW29DpG0sFEGIys0x+eGcb0aTS+uiApzZKObXWvX2nDg2RwSsAULrBcDIn4qxT6ooAtbvScwV1yJkqFPQAoA5NmBWiz2CaJ8lxUp5sNjRWKng6s2jlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiimV7XG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiimV7XG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE670C116B1;
	Tue, 16 Jul 2024 16:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145858;
	bh=8+1HwU6TBHtGHtEZa67CP78u+hTUm4IyMwQiCspDj9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiimV7XGaj0pIOCSuDFeDjcF7J1BatnJTbGx0syiW7C4iRd7Txig5OsMATvns5BLC
	 k+4btgQoi9JiAuLgbeBhebC4Uh6qhwCeJ/Vc9WoRXy2G6YqKaD127Fc7V6btPoBHTS
	 T7jkl4m0X+h2vIxQ/hdNUhWPzEA243kjSKI/q0K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 6.6 105/121] [PATCH] selftests/net: fix gro.c compilation failure due to non-existent opt_ipproto_off
Date: Tue, 16 Jul 2024 17:32:47 +0200
Message-ID: <20240716152755.369817923@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: John Hubbard <jhubbard@nvidia.com>

Linux 6.6 does not have an opt_ipproto_off variable in gro.c at all (it
was added in later kernel versions), so attempting to initialize one
breaks the build.

Fixes: c80d53c484e8 ("selftests/net: fix uninitialized variables")
Cc: <stable@vger.kernel.org> # 6.6
Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Closes: https://lore.kernel.org/all/8B1717DB-8C4A-47EE-B28C-170B630C4639@cloudflare.com/#t
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/gro.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -113,9 +113,6 @@ static void setup_sock_filter(int fd)
 		next_off = offsetof(struct ipv6hdr, nexthdr);
 	ipproto_off = ETH_HLEN + next_off;
 
-	/* Overridden later if exthdrs are used: */
-	opt_ipproto_off = ipproto_off;
-
 	if (strcmp(testname, "ip") == 0) {
 		if (proto == PF_INET)
 			optlen = sizeof(struct ip_timestamp);


