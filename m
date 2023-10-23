Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126F114A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwZFlvFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80965C433C9;
	Mon, 23 Oct 2023 11:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059144;
	bh=iUs9Nu26qnTF5TyFyh0AW67Zg8jppUS5jQkoKkxEKBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwZFlvFnPiFGPpnaxPgNjwT4ZIMqRVGEBBlVJZiqKXFg77TwWfvR882yXQMN+MT1o
	 M3Qf967krt0FCWEVElubPANAX0Ul+tJe+9BaqE1dVOXl2GtXCgWZZnEfG/OCIXgOcT
	 SW3lkYxIdv88ZOFtYxZ4PWxGw2vvYMAZMIezDIIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Conole <aconole@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.5 078/241] selftests: openvswitch: Catch cases where the tests are killed
Date: Mon, 23 Oct 2023 12:54:24 +0200
Message-ID: <20231023104835.789829165@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Conole <aconole@redhat.com>

commit af846afad5ca1c1a24d320adf9e48255e97db84e upstream.

In case of fatal signal, or early abort at least cleanup the current
test case.

Fixes: 25f16c873fb1 ("selftests: add openvswitch selftest suite")
Signed-off-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/openvswitch/openvswitch.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/net/openvswitch/openvswitch.sh
+++ b/tools/testing/selftests/net/openvswitch/openvswitch.sh
@@ -3,6 +3,8 @@
 #
 # OVS kernel module self tests
 
+trap ovs_exit_sig EXIT TERM INT ERR
+
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 


