Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061677;
	b=x8LGQSZm6wxevVl0QaLSwuvvvvkaVQvb4I1muM84ngDurZ6YADbljBsfElO982acd/U/
	 VrW0qoKN577+CV6vI/iqrJlEHr2nerpEfIs9/2yPTa9tRl4srJwmaEgUseAJp6SJjkiag
	 mOk8m9DhbfmQAkOX9fnc2bGSDb7K/z0Qvd0jxIc7Rmc1/NhKPTkYQ51wURhRlvLZKpTpp
	 041AhVoLQMbGhX8tCxriK3bvF0JIvPV9s+hPDFMlODIIZ61CeLYXnx3iFliWjmH7Qxr73
	 qFrfJqoADCydgQ9cz0I7Tk9xaY8nJWCJnJcSWx7hd8znzPjZXEjvADJTrJXAdFcY+PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oYQIMKr332yZW2u1Itg59dj2CYrtaeRwcI4F40FclOI=;
	b=jW60IOf41rKFxB+y2o2SdGuDLYYrh0q5mt0OWn6jcO9UWhHZjxzeQ1Lr94JeDdd8YvHg
	 BAI2yxwehQUECvJ0y5PFSINyJtR2g/6cutGbrb/NjjoJd16TuMWYzwID5tA6ZdJMe67MC
	 fZYkQGTo0YpzoLo/nGuJ0EJQ+9LUTk82sf0R36LI9a5qFiz80aKgx5nqLPsyV+krpJQ+G
	 E5HgDdlHD4CF27IGeRGIKDhjPGBOmxEriQPAOtOnqTseccW7ybNXow5nXQPfFwjsJLJns
	 hJNrM0yzYeQOz/UQU7LFufTruKo0NajBYxtK36dnHRRWeJsuzGxBVhWW1JMz4Xu5tfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xBit50pW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA4B606A32D;
	Sat,  7 Nov 2026 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xBit50pW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682BE1F008A1;
	Sat,  7 Nov 2026 14:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061676;
	bh=oYQIMKr332yZW2u1Itg59dj2CYrtaeRwcI4F40FclOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBit50pWijbSxKSfg+EvgKMieRoBjfgtZ5xRwZYhK3PaNh7e8KMSbBWRRzXukr08I
	 Emln4RbV3AiisUm3GybrJJ0DCNgSgM44nYnK/QELSGObGz8SgKbaQ0J5w5etuv55Zs
	 oSdFLduDqBbuHt6it3ThNMnCosyh9xtoTf99f+sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0730/1536] xfs: bound da-node entry count against the correct geometry
Date: Sat,  7 Nov 2026 08:45:46 -0500
Message-ID: <20261107135018.007297386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 3df5e5aaa3bc0913236c48ab29b7df3a785aa29f upstream.

xfs_da3_node_verify() bounds the node entry count against the larger of
the directory and attribute geometries because, as a buffer verifier, it
cannot tell whether the block belongs to the directory or the attribute
tree. When the directory block size exceeds the fs block size (e.g.
mkfs.xfs -n size=64k -b size=4k), an attribute node buffer is a single fs
block that holds only m_attr_geo->node_ents entries, yet a crafted attr
node may claim a count up to m_dir_geo->node_ents and still pass the
verifier.

xfs_da3_node_lookup_int() then indexes btree[] up to that count during
its binary search -- an out-of-bounds read via getxattr/listxattr on a
mounted crafted image.

The buffer verifier is the wrong place to tighten this: it has no fork
context, and the transaction-less read path used by getxattr does not run
xfs_da3_node_set_type() either. xfs_da3_node_lookup_int(), on the other
hand, always runs on that path and holds args->geo, the geometry of the
fork actually being searched. Bound the entry count against
args->geo->node_ents there, before walking the entries.

Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_da_btree.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1787,6 +1787,20 @@ xfs_da3_node_lookup_int(
 		} else
 			expected_level--;
 
+		/*
+		 * The node verifier cannot tell whether this block belongs to
+		 * the directory or the attribute tree, so it only bounds the
+		 * entry count against the larger of the two geometries.  Here
+		 * args->geo is the geometry of the fork we are actually
+		 * searching, so reject a count that would walk btree[] off the
+		 * end of this node buffer.
+		 */
+		if (nodehdr.count > args->geo->node_ents) {
+			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
+			return -EFSCORRUPTED;
+		}
+
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 


