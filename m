Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1947614AD0E;
	Thu, 23 May 2024 13:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470735; cv=none; b=pAuyW2gTscCE4YcM8s0t7+nR54Zrf9Ic77nrkLF+aF1kLOxALtiV52CATv4Ivux5lOUaeTRYy5BcxYHYVCgw4t3djMwTKOqk9h3EHKUQriiYz5IzvRGY/0LLChLRZ3fNjocxW5j7WFvrI4sPPdLZYeyvpNXQ4I96rCIUxDTOsOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470735; c=relaxed/simple;
	bh=VVUkQGOjyW3b6ExzWPVjwjbRIE80MKw9cRNuSeYNOKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRAMHaIOc4VDGGzGTEYij3jEiCzBoggFIqD4KwyS3BfZyLbUnVlGxAlYmk4BFgaZOjZHN19WeFeD4FTFHtZ+qZnH2SGIoLdvt3/r/b/3LWjHP4JNxR55zMDkPtdQLoQ2JltyX3DIRjFlRVf7HQekJAqLXu715zezYLNBatdWxvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuJo0JZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuJo0JZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C57C2BD10;
	Thu, 23 May 2024 13:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470735;
	bh=VVUkQGOjyW3b6ExzWPVjwjbRIE80MKw9cRNuSeYNOKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuJo0JZKx+jOvPRlCwSWV0EaFImsAcWn3MmcU3Rg5lv6rtGasgaC3gcCG2IInHX3+
	 2hRdOFtIdtGGmsXgU78d3yZoIxEV8cIkQZRlT4fHpRaNsdCGhIDcZVAUktV8gQBSh6
	 YBgPoKeSkUyOPpcwSa3p0/IC0B1KGszW7Si1IDv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/102] smb311: correct incorrect offset field in compression header
Date: Thu, 23 May 2024 15:13:34 +0200
Message-ID: <20240523130345.071844031@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 68c5818a27afcb5cdddab041b82e9d47c996cb6a ]

The offset field in the compression header is 32 bits not 16.

Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reported-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 61c6e72ccddc4..735614d233a06 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -227,7 +227,7 @@ struct smb2_compression_hdr {
 	__le32 OriginalCompressedSegmentSize;
 	__le16 CompressionAlgorithm;
 	__le16 Flags;
-	__le16 Offset; /* this is the size of the uncompressed SMB2 header below */
+	__le32 Offset; /* this is the size of the uncompressed SMB2 header below */
 	/* uncompressed SMB2 header (READ or WRITE) goes here */
 	/* compressed data goes here */
 } __packed;
-- 
2.43.0



