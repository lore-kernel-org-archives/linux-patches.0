Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276D11494D9;
	Tue, 26 Aug 2025 13:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213328; cv=none; b=aW0iisk7SJhEG1gIxrZ3oRkWLXd83SWQoWLk3baroIIYKqN91U5dGbtX96rA6pLr3VhGeSEy2bLQwsTiw4Y1nxqLBIwc/oAN/A+hZ+FcOsPGDEFMdrSMv4f3wrAWpy5vfTnSq+iFpWIOuIAlZvRH05U1912s7qy5J2a6k2oYBuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213328; c=relaxed/simple;
	bh=SiUtgdf1+9CcT8KPzea7mDUXYygqb935iwpIGD5pj0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhIEn9BfHdAa/858u0EEahty7rFzPlpW2huWegUMzu6glig+5VsHak3NAHkaRTqxqPUROqIVLi87LafSB4sY9S/wEuML50TOKUjsw45oQKiavW1TDtdkTAlzSZg1tcFurtm+omFJC7ZWCLOgOL0i19ass4HoxDjt5iI3Rk8QvVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1cwOY07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1cwOY07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD406C4CEF1;
	Tue, 26 Aug 2025 13:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213328;
	bh=SiUtgdf1+9CcT8KPzea7mDUXYygqb935iwpIGD5pj0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1cwOY076qJ/stt4RqB7UAuku1UFEE8ZRBOCKALi/OZkQmVXucSqVIjLq3HTxg7Nw
	 NOyYR3+z0Znrvdc6GVnFqDMuyfw2VCyw7ytbKqGM4uRFJR1JcYson/caNa5lLI8hEG
	 d3YICwxvOtXuPrfjP2gNPpCeICY1jSzFkgw8l2qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 307/587] thunderbolt: Fix copy+paste error in match_service_id()
Date: Tue, 26 Aug 2025 13:07:36 +0200
Message-ID: <20250826111000.729785508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 5cc1f66cb23cccc704e3def27ad31ed479e934a5 upstream.

The second instance of TBSVC_MATCH_PROTOCOL_VERSION seems to have been
intended to be TBSVC_MATCH_PROTOCOL_REVISION.

Fixes: d1ff70241a27 ("thunderbolt: Add support for XDomain discovery protocol")
Cc: stable <stable@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20250721050136.30004-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -36,7 +36,7 @@ static bool match_service_id(const struc
 			return false;
 	}
 
-	if (id->match_flags & TBSVC_MATCH_PROTOCOL_VERSION) {
+	if (id->match_flags & TBSVC_MATCH_PROTOCOL_REVISION) {
 		if (id->protocol_revision != svc->prtcrevs)
 			return false;
 	}


