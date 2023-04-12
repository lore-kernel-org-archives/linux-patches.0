Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825352F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023A3C433D2;
	Wed, 12 Apr 2023 08:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289166;
	bh=9jh4Wsyk0CX4D55AfrFbuDaWosDMOx4uwsUkGlHZO4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aO7OsyR04v/N3DLdjlzSbG2IPj9BMyhMnor1N//4AasdmHKgplRIsBv0vHQNLmurH
	 5RTrwl+yjMceTWWdHAq0FK3oRAdJK/0S+KP7poAQoIJQOrY3SibuTGQD2G5+d7g5EX
	 IeGfStWb/pw/15WAol28USIyzLrNJrCqEFlPwBWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 161/164] maple_tree: remove extra smp_wmb() from mas_dead_leaves()
Date: Wed, 12 Apr 2023 10:34:43 +0200
Message-Id: <20230412082843.476610743@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 8372f4d83f96f35915106093cde4565836587123 upstream.

The call to mte_set_dead_node() before the smp_wmb() already calls
smp_wmb() so this is not needed.  This is an optimization for the RCU mode
of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-5-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5495,7 +5495,6 @@ unsigned char mas_dead_leaves(struct ma_
 			break;
 
 		mte_set_node_dead(entry);
-		smp_wmb(); /* Needed for RCU */
 		node->type = type;
 		rcu_assign_pointer(slots[offset], node);
 	}


