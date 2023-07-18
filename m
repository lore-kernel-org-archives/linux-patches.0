Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635711FA0
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 05:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC44C433B9;
	Tue, 18 Jul 2023 05:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689658128;
	bh=5/I2Oo1+eHlrU9kha5F8okWuBWfq/jmwWetfxpBFOJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdH81+504C2TaP6gx9HufIlfw8IIMaE9uFiGR3yaVJJRfnpL3rpnKiANN+/eBP7hl
	 m15PXsyYE1OfIkODRedBtuxMAQtsq3BqcMPqD0pO1aF5Bh9J3vHTISRGHE4fc2LAky
	 F7HdpvrowMyClU6BmlV4JZrM8BZh7poS7VgHThJxlII8LreS/vzyTsQcxJSTVK9bwb
	 ipNAID5mW1qj68kXATmFM5b+ncEcRB70jS5eEmD0Q4w9VatpCWakqWR3YxtTNg7YeE
	 ppfrzrjUBXAWMd/qereojk/RCkrT4PuDKMnVTnE8U/AkfHnY2nS7kbJmnHOfmAgltX
	 L2MtbmqHjEKVg==
From: Miguel Ojeda <ojeda@kernel.org>
To: David Gow <davidgow@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH v2 7/7] MAINTAINERS: add Rust KUnit files to the KUnit entry
Date: Tue, 18 Jul 2023 07:27:52 +0200
Message-ID: <20230718052752.1045248-8-ojeda@kernel.org>
In-Reply-To: <20230718052752.1045248-1-ojeda@kernel.org>
References: <20230718052752.1045248-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KUnit maintainers would like to maintain these files on their
side too (thanks!), so add them to their entry.

With this in place, `scripts/get_maintainer.pl` prints both sets
of maintainers/reviewers (i.e. KUnit and Rust) for those files,
which is the behavior we are looking for.

Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3be1bdfe8ecc..2a942fe59144 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11372,6 +11372,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git k
 F:	Documentation/dev-tools/kunit/
 F:	include/kunit/
 F:	lib/kunit/
+F:	rust/kernel/kunit.rs
+F:	scripts/rustdoc_test_*
 F:	tools/testing/kunit/
 
 KERNEL USERMODE HELPER
-- 
2.41.0

