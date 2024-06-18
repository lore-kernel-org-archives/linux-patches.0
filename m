Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9026F1B1405;
	Tue, 18 Jun 2024 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714556; cv=none; b=OtFOImcw+CgXKdN2j/a3KzZCjFosdmnV/Rrh29tuvG+2LI/wRmXozkRTFvvtMa+jMpukAJ9VbX6u7iioc1hv32O+8gOmX0XDuqQOQG+d01ZqiTl67tRdeM+IJUvdvB+UFb8WViQVpMkhMuzIz+NaVDP2AB5mT6sjShBkCTEPehc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714556; c=relaxed/simple;
	bh=RtWIjNRt8jiOhB+CcOs+VfXqMwuya7eMryaFWSDaeGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDWKVjQ7J0j8KlbzJeQVvLIxjX/yTG9i8dB+3Bf2oBPpKNrE5KTS8ITvGTTui/kPen4H/6NBC2vMiGeti9JrZkKePHNG8RzplN8UXMRO1gjg8FCDThUyWibR+GfM9kxNe5NUqr7GrTBTIvjR1FR0dpkt4w/fbZNDkExuuYATHUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdm6qcDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdm6qcDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ED4C4AF49;
	Tue, 18 Jun 2024 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714556;
	bh=RtWIjNRt8jiOhB+CcOs+VfXqMwuya7eMryaFWSDaeGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdm6qcDyrnxCV7+XtDEN2E26SnGBrg2TsyY4+rJhgl8+eeWehF1928uzAOn+2All4
	 q4+SPzZ7TtbwSHhzyakRPL52v0U8iX47bMSIpsetD0LZyTnGSIGQQnIpqF5MauSuM4
	 2vk6OJt2xJZoN4Cv8mOJqHjW9JdnYMOzeLnZt3d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/770] NFSD: A semicolon is not needed after a switch statement.
Date: Tue, 18 Jun 2024 14:27:36 +0200
Message-ID: <20240618123407.422104787@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Rix <trix@redhat.com>

[ Upstream commit 25fef48bdbe7cac5ba5577eab6a750e1caea43bc ]

Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4b3344296ed0e..fd9107332a20f 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2558,7 +2558,7 @@ static u32 nfs4_file_type(umode_t mode)
 	case S_IFREG:	return NF4REG;
 	case S_IFSOCK:	return NF4SOCK;
 	default:	return NF4BAD;
-	};
+	}
 }
 
 static inline __be32
-- 
2.43.0



