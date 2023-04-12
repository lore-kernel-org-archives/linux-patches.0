Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBAD2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FC6C433D2;
	Wed, 12 Apr 2023 08:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289624;
	bh=3881UuZ4BoDLzMRCKa2SRC6G43q6RC6Vw50l3KLlNC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdGbzyuk/rfHj3u4JGTzft5N8+uFPfWi8zjPSN0xRfhuSyPLEYlMvVY1nCGxBuuw2
	 LVmNeuNUCEEaU2hj/IUMj1K77g+nOJcwmmruZORVgrr7iGw2a79psFlz/ecWwbnGgq
	 3UrnRx2UNnEhbc8iyKklxtpU87Aa+GHLD45hQPV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.2 170/173] maple_tree: remove extra smp_wmb() from mas_dead_leaves()
Date: Wed, 12 Apr 2023 10:34:56 +0200
Message-Id: <20230412082845.042823332@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
@@ -5500,7 +5500,6 @@ unsigned char mas_dead_leaves(struct ma_
 			break;
 
 		mte_set_node_dead(entry);
-		smp_wmb(); /* Needed for RCU */
 		node->type = type;
 		rcu_assign_pointer(slots[offset], node);
 	}


