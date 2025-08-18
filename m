Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D75335BA9;
	Mon, 18 Aug 2025 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524468; cv=none; b=uLw35/0/lY8XIIBS2QO/qL3UPYcR5vO+77G/9c5O2TYC/6WMqb5wfC70p509z6isS+TSlZtupHUM6YUGcEl3NdHBl7ba6BOrXM2OPVRLXK4F58fGCZC7z+4ucKywDwV++RGt+/jKMmn5NJA/JDjm2DYG4xt8N3HQgikitfI3Bbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524468; c=relaxed/simple;
	bh=in+6+yEi3UydAO5vSL2IIaAVrb9vNBv43vZKDqwFlQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2Gr0MNE8b3z+V7nsMmN6NdxvmD6y++W6M0uXOufzpEFTMlURQHoOf9Ork2wOOuAWy/SQb6hpQnoMvWNFbfYQOMcejGuHyuc4fssX5VN6wNpP6Qg0fwWPF/LBW96ez09PK/2gx2AxTO3iKhlRUAE8Z+h2uv89OWdWJdRmCazLVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNQewry0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNQewry0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F86BC116D0;
	Mon, 18 Aug 2025 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524468;
	bh=in+6+yEi3UydAO5vSL2IIaAVrb9vNBv43vZKDqwFlQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNQewry0P6wcSwYcq7TGw13mVtnyRx0GB22pMcbQT4MNNW9xM7l0i9yhfpcmqoAxf
	 b+8qTum5hNSjDpiP4bFge0bzpTPUetTC5VxatHTa5GGyz1IW3CXjNNUQzSxKlKtbE9
	 DWv2hqo3uQnDc4hUnTB/kSJo8h0TH7GfS2ni5Zf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.15 482/515] xfs: fix scrub trace with null pointer in quotacheck
Date: Mon, 18 Aug 2025 14:47:48 +0200
Message-ID: <20250818124516.978234222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Albershteyn <aalbersh@redhat.com>

commit 5d94b19f066480addfcdcb5efde66152ad5a7c0e upstream.

The quotacheck doesn't initialize sc->ip.

Cc: stable@vger.kernel.org # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -479,7 +479,7 @@ DECLARE_EVENT_CLASS(xchk_dqiter_class,
 		__field(xfs_exntst_t, state)
 	),
 	TP_fast_assign(
-		__entry->dev = cursor->sc->ip->i_mount->m_super->s_dev;
+		__entry->dev = cursor->sc->mp->m_super->s_dev;
 		__entry->dqtype = cursor->dqtype;
 		__entry->ino = cursor->quota_ip->i_ino;
 		__entry->cur_id = cursor->id;


