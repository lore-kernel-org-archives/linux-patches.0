Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831562;
	b=qbaZlzQL/Jc3YKheXxqLGz/Kj3r+9hRGEt62fm/Psv7flbkgqGMlC075/fTdVcpIQ4kg
	 9ZzTWqBxuNUUTVLcqKJycsbYhBVxxKNSIAUIF/QiN5L2Mn6/aO50BSUItZcwf9pak2exD
	 tG9ZiMqaWR3WrWhWG94br2COm8pC3+VlPcPr+JQraXymyTCnbWaChuuPnc3SrALoI52sY
	 i5XIzLfp/pWqc5mj+Djsiw+LegCD6V2hCMN6kHl3+KAJ/gByjmkflhrW/N8rwmjCdXwfH
	 BPBKKqViS/IyDgBX2RQFmTZV5M+FjvfXPjUs8ODBMOmrnZFlKfb9v1gHl6sNTTG/G5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zlOQ+46CkqAeV3KmtIQOFB4Ewt5VDjk7KDxHbprnR5s=;
	b=hUIw8zgOWNTv/LrwQU9jpE2nFVEfHOTX8UUoG4XYAufxCl1c0eAFtUHShraICqpNNpLq
	 DB9+DYqlbuG1oQdPOhC/ZpYw03v/o+J4Fm46rqgY+sJqxez8GtsvFT/oyL7s87AGUsQ6J
	 3x/P0hOLIgOsxHAF/Y0PJvgwIvLMceC5KK2/bDTjNWzspGunoUxrl4GWGTEYUZzPIrIQH
	 rB+2GobPfLYuJqaojWa4TNYO093PRy1j4u+F96YSRSkUuEBbcDVYIxGNqCL6IdcEOR83D
	 dTsrYGcOfQcxfb7hXEQRw7YCm0WU41zX6cHO6v1FcwCHAWC6fEQOPuiXVoAU2nFXnfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MPutW52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40270606A844;
	Wed,  4 Nov 2026 22:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MPutW52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6501F000C1;
	Wed,  4 Nov 2026 22:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831561;
	bh=zlOQ+46CkqAeV3KmtIQOFB4Ewt5VDjk7KDxHbprnR5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0MPutW52Fop0X/kqeXs4KnV19rTZPdlchY6OS3tMDFvKhB08J+vg9D4DA8/baJe3h
	 OKgVPjeEGGU3PFlesSQPIroo1Z32NSMqMqBwakvuhqVjsQGODjYZLAvEtVQLiPkLW6
	 YhVxrUxvJmAAezdUE2AObXbaubBisbMYbXR9uFVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0777/1005] xfs: fix xfs_rename_space_res for non-pptr filesystems
Date: Wed,  4 Nov 2026 16:08:30 -0500
Message-ID: <20261104211105.139627829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit a800b926346c3aa2482421f5c0272280ee7d32e8 upstream.

We don't need to reserve space for a parent pointer update for an
existing target if parent pointers are disabled.  Fix this regression
(which LOLLM noticed) so that rename reservations go back to what they
were before parent pointers.

Cc: stable@vger.kernel.org # v6.10
Fixes: 5a8338c88284df ("xfs: Add parent pointers to rename")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_trans_space.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -112,10 +112,10 @@ xfs_rename_space_res(
 		if (has_whiteout)
 			ret += xfs_parent_calc_space_res(mp, src_namelen);
 		ret += 2 * xfs_parent_calc_space_res(mp, target_namelen);
-	}
 
-	if (target_exists)
-		ret += xfs_parent_calc_space_res(mp, target_namelen);
+		if (target_exists)
+			ret += xfs_parent_calc_space_res(mp, target_namelen);
+	}
 
 	return ret;
 }


